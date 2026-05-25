-- local-cscope: Cscope integration with telescope and database auto-discovery
local M = {}

function M.setup()
  -- Patch vim.system to rewrite cscope's -f and -P as absolute paths.
  -- cscope_maps computes them relative to Neovim's CWD, which breaks
  -- when CWD differs from the project root (e.g. CWD=/).
  -- Absolute paths work regardless of cscope's CWD.
  if not M._patched then
    M._patched = true
    local _vim_system = vim.system
    vim.system = function(cmd, opts)
      if type(cmd) == "table" and cmd[1] == "cscope" then
        cmd = vim.deepcopy(cmd)
        local cwd = vim.fn.getcwd()
        for i, arg in ipairs(cmd) do
          if arg == "-f" and cmd[i+1] and not vim.fn.isabsolutepath(cmd[i+1]) then
            cmd[i+1] = vim.fs.normalize(vim.fs.joinpath(cwd, cmd[i+1]))
          elseif arg == "-P" and cmd[i+1] then
            local db = require("cscope.db")
            local conn = db.primary_conn()
            if conn and conn.pre_path and conn.pre_path ~= "" then
              cmd[i+1] = conn.pre_path
            end
          end
        end
      end
      return _vim_system(cmd, opts)
    end
  end

  local cscope_module = require("cscope_maps")
  cscope_module.setup({
    disable_maps = true,
    disable_telescope = false,
    cscope = {
      exec = "cscope",
      picker = "telescope",
      skip_picker_for_single_result = true,
      project_rooter = { enable = false },
    },
  })

  -- Fixup helper: convert CWD-relative paths to project-root-relative.
  local function fixup_paths(entries)
    local db = require("cscope.db")
    local conn = db.primary_conn()
    local root = conn and conn.pre_path
    if not root or root == "" then return end
    local real_root = vim.uv.fs_realpath(root) or root
    for _, entry in ipairs(entries) do
      local fname = entry.filename
      if fname and type(fname) == "string"
         and not vim.startswith(fname, "/")
         and not vim.startswith(fname, "~") then
        local abs_path = vim.fs.normalize(vim.fs.joinpath(vim.fn.getcwd(), fname))
        local real_abs = vim.uv.fs_realpath(abs_path)
        if real_abs and vim.startswith(real_abs, real_root .. "/") then
          entry.filename = real_abs:sub(#real_root + 2)
        elseif vim.startswith(abs_path, root .. "/") then
          entry.filename = abs_path:sub(#root + 2)
        end
      end
    end
  end

  -- Patch open_picker to fix paths after parse_output but before
  -- telescope renders them.  Also patch get_abs_path / open_file
  -- so project-root-relative paths resolve correctly.
  if not M._patched_path then
    M._patched_path = true
    local cs = require("cscope")
    local cs_utils = require("cscope_maps.utils")
    local _open_picker = cs.open_picker
    local _open_file = cs_utils.open_file

    cs.open_picker = function(op_s, symbol, parsed_output)
      fixup_paths(parsed_output)
      return _open_picker(op_s, symbol, parsed_output)
    end

    cs_utils.get_abs_path = function(path)
      if vim.startswith(path, "/") or vim.startswith(path, "~") then
        return vim.fs.normalize(path)
      end
      local db = require("cscope.db")
      local conn = db.primary_conn()
      local base = (conn and conn.pre_path and conn.pre_path ~= "")
        and conn.pre_path or vim.fn.getcwd()
      return vim.fs.normalize(vim.fs.joinpath(base, path))
    end

    cs_utils.open_file = function(fname, lnum, split)
      if not vim.startswith(fname, "/") and not vim.startswith(fname, "~") then
        local db = require("cscope.db")
        local conn = db.primary_conn()
        local base = (conn and conn.pre_path and conn.pre_path ~= "")
          and conn.pre_path or vim.fn.getcwd()
        fname = vim.fs.normalize(vim.fs.joinpath(base, fname))
      end
      return _open_file(fname, lnum, split)
    end
  end

  local function find_git_root()
    local dir = vim.fn.expand("%:p:h")
    if dir == "" then dir = vim.fn.getcwd() end
    dir = vim.uv.fs_realpath(dir) or dir
    while dir and dir ~= "/" do
      if vim.fn.isdirectory(dir .. "/.git") == 1 then
        return dir
      end
      dir = vim.fn.fnamemodify(dir, ":h")
    end
    return nil
  end

  local function find_cscope_databases()
    local dbs = {}
    local current_dir = vim.fn.getcwd()
    local git_root = find_git_root()
    local stop_dir = git_root or vim.fn.expand("~")
    local search_dir = current_dir
    while search_dir and #search_dir > 1 do
      local cscope_file = search_dir .. "/cscope.out"
      if vim.fn.filereadable(cscope_file) == 1 then
        table.insert(dbs, cscope_file)
      end
      local patterns = { "cscope.*.out", "*.cscope.out", ".cscope/cscope.out", "tags/cscope.out" }
      for _, pattern in ipairs(patterns) do
        local found = vim.fn.globpath(search_dir, pattern, false, true)
        for _, db in ipairs(found) do
          if vim.fn.filereadable(db) == 1 then
            table.insert(dbs, db)
          end
        end
      end
      if search_dir == stop_dir then break end
      local parent = vim.fn.fnamemodify(search_dir, ":h")
      if parent == search_dir then break end
      search_dir = parent
    end
    if git_root and git_root ~= current_dir then
      local git_cscope = git_root .. "/cscope.out"
      if vim.fn.filereadable(git_cscope) == 1 then
        table.insert(dbs, git_cscope)
      end
    end
    local seen = {}
    local unique_dbs = {}
    for _, db in ipairs(dbs) do
      if not seen[db] then
        seen[db] = true
        table.insert(unique_dbs, db)
      end
    end
    return unique_dbs
  end

  -- Cache the first successfully loaded DB's real source directory so
  -- cscope keeps working when CWD moves away from the project root.
  local cached_db_dir = nil

  local function load_databases()
    local dbs = find_cscope_databases()
    require("cscope.db").reset()
    if #dbs == 0 then
      if cached_db_dir then
        -- CWD has no cscope.out; reuse cached project DB.
        -- Use explicit pre_path (db dir) so path resolution is always
        -- anchored to the real project root, not Neovim's CWD.
        require("cscope_maps").setup({
          disable_maps = true, disable_telescope = false,
          cscope = {
            exec = "cscope", picker = "telescope",
            skip_picker_for_single_result = true,
            project_rooter = { enable = false },
            db_file = cached_db_dir .. "/cscope.out" .. "::" .. cached_db_dir,
          },
        })
        return { cached_db_dir .. "/cscope.out" }
      end
      -- vim.notify("No cscope databases found", vim.log.levels.WARN)
      return {}
    end
    -- Set pre_path to the cscope DB's own directory (the project root)
    -- instead of relying on project_rooter, which returns getcwd() when
    -- the db path is absolute — breaking when CWD != project root.
    local db_path = dbs[1]
    local db_dir = vim.fs.dirname(db_path)
    require("cscope_maps").setup({
      disable_maps = true, disable_telescope = false,
      cscope = {
        exec = "cscope", picker = "telescope",
        skip_picker_for_single_result = true,
        project_rooter = { enable = false },
        db_file = db_path .. "::" .. db_dir,
      },
    })
    -- Cache the real source directory for reuse when CWD moves away
    cached_db_dir = vim.uv.fs_realpath(db_dir) or db_dir
    for i = 2, #dbs do
      local d = vim.fs.dirname(dbs[i])
      vim.cmd("Cscope db add " .. dbs[i] .. "::" .. d)
    end
    vim.notify("Loaded " .. #dbs .. " cscope database(s)", vim.log.levels.INFO)
    return dbs
  end

  local function get_visual_selection()
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")
    local lines = vim.api.nvim_buf_get_lines(0, start_pos[2] - 1, end_pos[2], false)
    if #lines == 0 then return "" end
    lines[1] = lines[1]:sub(start_pos[3], -1)
    if #lines > 1 then
      lines[#lines] = lines[#lines]:sub(1, end_pos[3])
    end
    return table.concat(lines, "\n")
  end

  local map_opts = { silent = true, noremap = true }

  vim.keymap.set('n', '<leader>fs', ":Cscope find s <C-r><C-w><CR>",
    vim.tbl_extend("force", map_opts, { desc = "Find references (Telescope)" }))
  vim.keymap.set('n', '<leader>fd', ":Cscope find g <C-r><C-w><CR>",
    vim.tbl_extend("force", map_opts, { desc = "Find definition (Telescope)" }))
  vim.keymap.set('n', '<leader>fc', ":Cscope find c <C-r><C-w><CR>",
    vim.tbl_extend("force", map_opts, { desc = "Find callers (Telescope)" }))
  vim.keymap.set('n', '<leader>fC', ":Cscope find d <C-r><C-w><CR>",
    vim.tbl_extend("force", map_opts, { desc = "Find callees (Telescope)" }))
  vim.keymap.set('n', '<leader>fw', ":Cscope find a <C-r><C-w><CR>",
    vim.tbl_extend("force", map_opts, { desc = "Find assignments (Telescope)" }))
  vim.keymap.set('n', '<leader>fe', function()
    vim.ui.input({ prompt = "Egrep pattern: " }, function(input)
      if input and input ~= "" then vim.cmd("Cscope find e " .. input) end
    end)
  end, vim.tbl_extend("force", map_opts, { desc = "Egrep pattern (Telescope)" }))
  vim.keymap.set('n', '<leader>fb', ":Cscope db build<CR>",
    vim.tbl_extend("force", map_opts, { desc = "Build cscope database" }))
  vim.keymap.set('v', '<leader>fs', function()
    local selection = get_visual_selection()
    if selection ~= "" then vim.cmd("Cscope find s " .. selection) end
  end, vim.tbl_extend("force", map_opts, { desc = "Find references (visual/Telescope)" }))
  vim.keymap.set('n', '<leader>fr', function() load_databases() end,
    vim.tbl_extend("force", map_opts, { desc = "Reload cscope databases" }))
  vim.keymap.set('n', '<leader>fz', function()
    local dbs = find_cscope_databases()
    vim.notify("Found " .. #dbs .. " cscope databases:\n" .. table.concat(dbs, "\n"), vim.log.levels.INFO)
  end, vim.tbl_extend("force", map_opts, { desc = "Debug: Show found databases" }))

  local function rg_fallback(cwd)
    return {
      prompt_title = "Find(rg)",
      cwd = cwd,
      find_command = function()
        return { "rg", "--files", "--hidden",
          "--glob", "!**/.git/*",
          "--glob", "!.cscope.files",
          "--glob", "!cscope*.out",
          "--glob", "!tags",
          "--glob", "!*.o",
          "--glob", "!*.obj",
          "--glob", "!*.a",
          "--glob", "!*.so",
          "--glob", "!*.dylib",
          "--glob", "!*.exe",
          "--glob", "!*.out",
          "--glob", "!*.class",
          "--glob", "!*.pyc",
          "--glob", "!__pycache__",
          "--glob", "!node_modules",
          "--glob", "!*.swp",
          "--glob", "!*.swo",
          cwd,
        }
      end,
    }
  end

  local function git_toplevel()
    return find_git_root() or vim.uv.fs_realpath(vim.fn.getcwd()) or vim.fn.getcwd()
  end

  -- <leader>ff: cscope.files -> .cscope.files -> git ls-files(tracked) -> rg
  local function leader_ff_opts()
    local cwd = vim.fn.getcwd()
    for _, name in ipairs({ "cscope.files", ".cscope.files" }) do
      local f = cwd .. "/" .. name
      if vim.fn.filereadable(f) == 1 then
        return { prompt_title = "Find(" .. name .. ")", cwd = cwd, find_command = { "cat", f } }
      end
    end
    local g = find_git_root()
    if g then
      return { prompt_title = "Find(git tracked)", cwd = g, find_command = { "git", "ls-files", "--cached" } }
    end
    return rg_fallback(git_toplevel())
  end

  -- ;ff: git ls-files(tracked+untracked) -> rg
  local function semicolon_ff_opts()
    local g = find_git_root()
    if g then
      return { prompt_title = "Find(git all)", cwd = g,
        find_command = { "git", "ls-files", "--cached", "--others", "--exclude-standard" } }
    end
    return rg_fallback(git_toplevel())
  end

  vim.keymap.set('n', '<leader>ff', function()
    require('telescope.builtin').find_files(leader_ff_opts())
  end, vim.tbl_extend("force", map_opts, { desc = "Find file (cscope/git/rg)" }))
  vim.keymap.set('n', ';ff', function()
    require('telescope.builtin').find_files(semicolon_ff_opts())
  end, vim.tbl_extend("force", map_opts, { desc = "Find file (git/rg)" }))

  load_databases()

  vim.api.nvim_create_autocmd("DirChanged", {
    pattern = "*",
    callback = function() load_databases() end,
  })
end

return M
