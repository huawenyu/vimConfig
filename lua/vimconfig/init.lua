-- vimConfig: Commands, keymaps, selection history, cross-window tracing
local M = {}

function M.setup()
  -- Commands
  vim.api.nvim_create_user_command("R", function(opts)
    vim.cmd("NeomakeRun! " .. opts.args)
  end, { nargs = "+", bang = true, complete = "shellcmd" })
  vim.api.nvim_create_user_command("Grep", function(opts)
    vim.cmd("call utilgrep#_Grep('grep" .. (opts.bang and "!" or "") .. "'," .. opts.args .. ")")
  end, { nargs = "*", bang = true, complete = "file" })
  vim.api.nvim_create_user_command("GrepAdd", function(opts)
    vim.cmd("call utilgrep#_Grep('grepadd" .. (opts.bang and "!" or "") .. "'," .. opts.args .. ")")
  end, { nargs = "*", bang = true, complete = "file" })
  vim.api.nvim_create_user_command("LGrep", function(opts)
    vim.cmd("call utilgrep#_Grep('lgrep" .. (opts.bang and "!" or "") .. "'," .. opts.args .. ")")
  end, { nargs = "*", bang = true, complete = "file" })
  vim.api.nvim_create_user_command("LGrepAdd", function(opts)
    vim.cmd("call utilgrep#_Grep('lgrepadd" .. (opts.bang and "!" or "") .. "'," .. opts.args .. ")")
  end, { nargs = "*", bang = true, complete = "file" })
  vim.api.nvim_create_user_command("SmartClose", function(opts)
    local function is_auxiliary(buffer)
      return not vim.bo[buffer].modifiable or not vim.bo[buffer].buflisted or vim.bo[buffer].buftype ~= ""
    end
    local current_buffer = vim.api.nvim_get_current_buf()
    if opts.bang or is_auxiliary(current_buffer) then
      vim.cmd("q")
    else
      local auxiliary_buffer = 0
      for _, b in ipairs(vim.api.nvim_list_bufs()) do
        if is_auxiliary(b) and b > auxiliary_buffer then
          auxiliary_buffer = b
        end
      end
      if auxiliary_buffer > 0 then
        vim.cmd(string.format("noautocmd %d wincmd w", vim.fn.bufwinnr(auxiliary_buffer)))
        vim.cmd("noautocmd q")
        vim.cmd(string.format("noautocmd %d wincmd w", vim.fn.bufwinnr(current_buffer)))
      else
        vim.cmd("q")
      end
    end
  end, { bang = true, nargs = 0 })

  local function selected_replace(mode)
    local save_cursor = vim.fn.getcurpos()
    local sel_str = vim.fn["hw#misc#GetWord"](mode)
    local nr = vim.fn.winnr()
    if vim.fn.getwinvar(nr, '&syntax') == 'qf' then
      vim.fn.setpos('.', save_cursor)
      return "%s/\\<" .. sel_str .. "\\>/" .. sel_str .. "/gI"
    else
      vim.cmd("delmarks un")
      vim.cmd("normal [[mu%mn")
      vim.cmd("redraw")
      return "'u,'ns/\\<" .. sel_str .. "\\>/" .. sel_str .. "/gI"
    end
  end

  -- Keymaps from conf_cmd.vim
  vim.keymap.set("v", "<leader>vr", function()
    vim.cmd(selected_replace('v'))
  end, { silent = true, desc = "Replace" })
  vim.keymap.set("n", "<leader>mk", ":AsyncStop! <bar> AsyncTask! wad<CR>", { silent = true, desc = "Make wad" })
  vim.keymap.set("n", "<leader>ma", ":AsyncStop! <bar> AsyncTask! sysinit<CR>", { silent = true, desc = "Make all" })
  vim.keymap.set("n", "<leader>mw", ":R! ~/tools/dict <C-R>=expand('<cword>')<cr>", { silent = true, desc = "Dictionary" })
  vim.keymap.set("n", "<leader>mf", ":call utilquickfix#QuickFixFilter()<CR>", { silent = true, desc = "Quickfix filter" })
  vim.keymap.set("n", "<leader>mc", ":call utilquickfix#QuickFixFunction()<CR>", { silent = true, desc = "Quickfix add caller" })
  vim.keymap.set("n", ";q", ":SmartClose<CR>", { silent = true, desc = "SmartClose" })

  -- vimConfig/conf_map.vim: Upper keyfixes
  if vim.g.vim_confi_option.upper_keyfixes then
    vim.api.nvim_create_user_command("E", function(opts)
      vim.cmd("e" .. (opts.bang and "!" or "") .. " " .. (opts.args or ""))
    end, { bang = true, nargs = "*" })
    vim.api.nvim_create_user_command("W", function(opts)
      vim.cmd("w" .. (opts.bang and "!" or "") .. " " .. (opts.args or ""))
    end, { bang = true, nargs = "*" })
    vim.api.nvim_create_user_command("Wq", function(opts)
      vim.cmd("wq" .. (opts.bang and "!" or ""))
    end, { bang = true, nargs = "?" })
    vim.api.nvim_create_user_command("WQ", function(opts)
      vim.cmd("wq" .. (opts.bang and "!" or ""))
    end, { bang = true, nargs = "?" })
    vim.api.nvim_create_user_command("Wa", function(opts)
      vim.cmd("wa" .. (opts.bang and "!" or ""))
    end, { bang = true })
    vim.api.nvim_create_user_command("WA", function(opts)
      vim.cmd("wa" .. (opts.bang and "!" or ""))
    end, { bang = true })
    vim.api.nvim_create_user_command("Q", function(opts)
      vim.cmd("q" .. (opts.bang and "!" or ""))
    end, { bang = true })
    vim.api.nvim_create_user_command("QA", function(opts)
      vim.cmd("qa" .. (opts.bang and "!" or ""))
    end, { bang = true })
    vim.api.nvim_create_user_command("Qa", function(opts)
      vim.cmd("qa" .. (opts.bang and "!" or ""))
    end, { bang = true })
  end

  -- vimConfig/conf_map.vim: Alt shortcuts
  if vim.g.vim_confi_option.alt_shortcut then
    vim.keymap.set("n", "<a-e>", "<leader>ve")
    vim.keymap.set("n", "<a-w>", "<leader>vw")
    vim.keymap.set("n", "<a-t>", "<leader>vt")
    vim.keymap.set("n", "<a-b>", "<leader>vb")
    vim.keymap.set("n", "<a-g>", "<leader>vg")
    vim.keymap.set("n", "<a-q>", "<leader>vq")
    vim.keymap.set("n", "<a-f>", ";fs")
    vim.keymap.set("n", "<a-s>", "<leader>g1")
    vim.keymap.set("n", "<a-/>", ":TodoLocList<cr>")
    vim.keymap.set("n", "<a-:>", ":AsyncTask tag4one<cr>")
    vim.keymap.set("n", "<a-'>", ":AsyncTask run<cr>")
    vim.keymap.set("n", ";w", ":wall<cr>", { desc = "[misc] Save all buffers *" })
    vim.keymap.set("x", ";w", ":<c-U>wall<cr>")
    if _G.HasPlug and _G.HasPlug("vim-motion") then
      vim.keymap.set("n", "<a-.>", "<Plug>_JumpPrevIndent")
      vim.keymap.set("n", "<a-,>", "<Plug>_JumpNextIndent")
      vim.keymap.set("x", "<a-.>", "<Plug>_JumpPrevIndent")
      vim.keymap.set("x", "<a-,>", "<Plug>_JumpNextIndent")
      vim.keymap.set("o", "<a-.>", "<Plug>_JumpPrevIndent")
      vim.keymap.set("o", "<a-,>", "<Plug>_JumpNextIndent")
    end
    vim.keymap.set("i", "<a-i>", '<c-r>"')
  end

  -- vimConfig/conf_map.vim: Basic mappings
  if vim.g.vim_confi_option.enable_map_basic then
    vim.keymap.set("n", "<C-c>", "<C-c>")
    vim.keymap.set("n", "<leader>q", function() vim.cmd("qa") end, { silent = true, desc = "[misc] Exit all *" })
    vim.keymap.set("x", "<leader>q", function() vim.cmd("qa") end, { silent = true })
    vim.keymap.set("i", "<S-Tab>", "<C-v><Tab>")

    vim.keymap.set({ "n", "x" }, "j", "gj")
    vim.keymap.set({ "n", "x" }, "k", "gk")
    vim.keymap.set("x", ">", ">gv")
    vim.keymap.set("x", "<", "<gv")

    vim.keymap.set('n', '<Return>', function()
      if vim.bo.buftype ~= 'quickfix' then
        vim.cmd("nohls")
        vim.cmd("nohls")
      end
      return '<CR>'
    end, { expr = true, silent = true, desc = "Clear search highlight" })

    vim.keymap.set("n", ";#", ":<c-u><c-u>%s///gn<cr>", { desc = "Count search pattern" })
    vim.keymap.set("n", ";^", ":<c-u>g//p<cr>", { desc = "[misc] Popup search pattern *" })
    vim.keymap.set("n", ";*", ":cexpr []<cr> | :<c-u>g//caddexpr expand('%') ..':' ..line('.') ..':0:' .. getline('.')<cr> | :copen<cr>", { desc = "Quickfix sink search" })
    vim.keymap.set("n", "<F1>", ":%s///gc<cr>", { desc = "[misc] Continue replace all search *" })
    vim.keymap.set("n", ";.", ":%s//<C-R>\"/gc<cr>", { desc = "[misc] Continue replace all search *" })
    vim.keymap.set("n", "<leader>.", "@@", { desc = "Repeat macro" })
    vim.keymap.set("n", "<Esc>", ":nohlsearch<CR><Esc>", { silent = true })
  end

  -- vimConfig/conf_map.vim: Useful mappings
  if vim.g.vim_confi_option.enable_map_useful then
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "c", "cpp" },
      callback = function()
        vim.keymap.set("n", "<leader>fa", function()
          vim.cmd("call JumpToCorrespondingFile()")
        end, { buffer = true, silent = true, desc = "[misc] Toggle source/header *" })
      end,
    })

    vim.keymap.set("n", "<leader>h", "<c-w>h", { desc = "Window left" })
    vim.keymap.set("n", "<leader>j", "<c-w>j", { desc = "Window down" })
    vim.keymap.set("n", "<leader>k", "<c-w>k", { desc = "Window up" })
    vim.keymap.set("n", "<leader>l", "<c-w>l", { desc = "Window right" })

    vim.keymap.set("n", "<c-n>", "<cmd>silent! cnext<cr>", { desc = "Next quickfix" })
    vim.keymap.set("n", "<c-p>", "<cmd>silent! cprev<cr>", { desc = "Previous quickfix" })
    vim.keymap.set("n", "<a-n>", "<cmd>silent! lne<cr>", { desc = "Next locallist" })
    vim.keymap.set("n", "<a-p>", "<cmd>silent! lp<cr>", { desc = "Previous locallist" })

    vim.keymap.set("t", "<c-h>", "<C-\\><C-n><C-w>h")
    vim.keymap.set("t", "<c-j>", "<C-\\><C-n><C-w>j")
    vim.keymap.set("t", "<c-k>", "<C-\\><C-n><C-w>k")
    vim.keymap.set("t", "<c-l>", "<C-\\><C-n><C-w>l")

    vim.keymap.set("n", "p", "p`]", { desc = "Paste and jump to end" })
    vim.keymap.set("x", "p", function()
      return "pgv\"" .. vim.v.register .. "y"
    end, { expr = true, desc = "Paste over selection" })

    vim.keymap.set("n", "<leader>vR", "gD:%s/<C-R>///g<left><left>", { desc = "Replace all" })

    vim.keymap.set("n", "<leader>o", "<C-o>", { desc = "Jump to older position" })
    vim.keymap.set("n", "<leader>i", "<C-i>", { desc = "Jump to newer position" })
  end

  -- Tab navigation
  vim.keymap.set('n', ';1', '1gt', { silent = true, desc = "Go to tab 1" })
  vim.keymap.set('n', ';2', '2gt', { silent = true, desc = "Go to tab 2" })
  vim.keymap.set('n', ';3', '3gt', { silent = true, desc = "Go to tab 3" })
  vim.keymap.set('n', ';4', '4gt', { silent = true, desc = "Go to tab 4" })
  vim.keymap.set('n', ';5', '5gt', { silent = true, desc = "Go to tab 5" })
  vim.keymap.set('n', ';6', '6gt', { silent = true, desc = "Go to tab 6" })
  vim.keymap.set('n', ';7', '7gt', { silent = true, desc = "Go to tab 7" })
  vim.keymap.set('n', ';8', '8gt', { silent = true, desc = "Go to tab 8" })
  vim.keymap.set('n', ';9', '9gt', { silent = true, desc = "Go to tab 9" })
  vim.keymap.set('n', ';0', ':tabonly<CR>', { silent = true, desc = "Close other tabs" })

  local function has_tags()
    local tags_option = vim.opt.tags:get()
    for _, path in ipairs(tags_option) do
      local expanded_path = vim.fn.expand(path)
      if vim.fn.filereadable(expanded_path) == 1 then
        return true
      end
    end
    return false
  end

  vim.keymap.set({'n', 'v'}, ';tt', function()
    local bufnr = vim.api.nvim_get_current_buf()
    local vtag = ""
    if has_tags() then
      vtag = vim.fn["utils#GetSelected"]('')
    end
    if vtag == "" then
      vim.cmd('silent! tab sb ' .. bufnr)
    else
      vim.cmd('silent! tab tag ' .. vtag)
    end
  end, { silent = true, desc = "Tag word into new tab" })

  -- Selection history
  M.history = {}
  M.index = 0
  local max_history = 20

  vim.api.nvim_create_autocmd("ModeChanged", {
    pattern = "[vV\x16]:*",
    callback = function()
      local buf = vim.api.nvim_get_current_buf()
      local mode = vim.fn.visualmode()
      local start_pos = vim.fn.getpos("'<")
      local end_pos = vim.fn.getpos("'>")
      if start_pos[2] == 0 or end_pos[2] == 0 then return end
      if #M.history > 0 then
        local last = M.history[#M.history]
        if last.buf == buf and last.start_pos[2] == start_pos[2] and last.end_pos[2] == end_pos[2] then
          return
        end
      end
      table.insert(M.history, {
        buf = buf, mode = mode, start_pos = start_pos, end_pos = end_pos
      })
      if #M.history > max_history then
        table.remove(M.history, 1)
      end
      M.index = #M.history + 1
    end
  })

  local function restore_selection(idx)
    local sel = M.history[idx]
    if not sel or not vim.api.nvim_buf_is_valid(sel.buf) then return end
    if vim.api.nvim_get_current_buf() ~= sel.buf then
      vim.api.nvim_set_current_buf(sel.buf)
    end
    vim.fn.setpos("'<", sel.start_pos)
    vim.fn.setpos("'>", sel.end_pos)
    vim.cmd("normal! gv")
  end

  vim.keymap.set("n", "g<", function()
    if #M.history == 0 then return end
    M.index = M.index > 1 and M.index - 1 or #M.history
    restore_selection(M.index)
  end, { desc = "Visual Selection - Previous" })

  vim.keymap.set("n", "g>", function()
    if #M.history == 0 then return end
    M.index = M.index < #M.history and M.index + 1 or 1
    restore_selection(M.index)
  end, { desc = "Visual Selection - Next" })

  -- Cross-window tracing: <leader><leader> on a word to jump in code window
  vim.keymap.set("n", "<leader><leader>", function()
    local sym = vim.fn.expand("<cword>")
    if sym == "" then return end

    local cur_win = vim.api.nvim_get_current_win()
    local function is_code_win(win)
      if not vim.api.nvim_win_is_valid(win) then return false end
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.bo[buf].buftype ~= "" then return false end
      return true
    end

    local code_win
    local wins = vim.api.nvim_tabpage_list_wins(0)
    if #wins == 1 then
      vim.cmd("rightbelow vsplit")
      code_win = vim.api.nvim_get_current_win()
      vim.api.nvim_set_current_win(cur_win)
    else
      local right_winnr = vim.fn.winnr("l")
      if right_winnr ~= vim.fn.winnr() then
        local right_win = vim.fn.win_getid(right_winnr)
        if is_code_win(right_win) then code_win = right_win end
      end
      if not code_win and is_code_win(cur_win) then code_win = cur_win end
      if not code_win then
        vim.cmd("rightbelow vsplit")
        code_win = vim.api.nvim_get_current_win()
        vim.api.nvim_set_current_win(cur_win)
      end
    end

    local file = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(code_win))
    if file == "" then return end
    local dir = vim.fn.getcwd()

    local db_dirs = { dir, vim.fs.dirname(dir) }
    local tag_names = { "tags", ".tags", "TAGS" }
    local cscope_names = { "cscope.out", ".cscope.out" }

    local function find_db(dirs, names)
      for _, d in ipairs(dirs) do
        if d and d ~= "" then
          for _, n in ipairs(names) do
            local p = vim.fs.joinpath(d, n)
            local stat = vim.uv.fs_stat(p)
            if stat and stat.type == "file" then return p end
          end
        end
      end
    end

    local tag_db = find_db(db_dirs, tag_names)
    local cscope_db = find_db(db_dirs, cscope_names)

    local rg_dirs = {}
    local function add_rg_dir(p)
      if not p or p == "" then return end
      p = vim.fs.normalize(p)
      if p == "/" then return end
      if not vim.tbl_contains(rg_dirs, p) then table.insert(rg_dirs, p) end
    end
    add_rg_dir(dir)
    add_rg_dir(vim.fs.dirname(dir))
    local git_top = vim.fn.systemlist({ "git", "-C", dir, "rev-parse", "--show-toplevel" })[1]
    add_rg_dir(git_top)

    local function jump(path, line, method)
      if not path or path == "" then return end
      vim.schedule(function()
        if not vim.api.nvim_win_is_valid(code_win) then return end
        vim.api.nvim_win_call(code_win, function()
          vim.cmd("edit " .. vim.fn.fnameescape(path))
          if line then vim.api.nvim_win_set_cursor(0, { tonumber(line), 0 }) end
          vim.cmd("normal! zz")
        end)
        vim.notify(string.format("[jump:%s] %s:%s", method or "?", vim.fn.fnamemodify(path, ":."), line or "?"),
          vim.log.levels.INFO, { title = "definition" })
      end)
    end

    local function try_tags()
      if not tag_db then return false end
      local old_tags = vim.o.tags
      vim.o.tags = tag_db
      local ok, res = pcall(vim.fn.taglist, "^" .. vim.pesc(sym) .. "$")
      if not ok or vim.tbl_isempty(res) then vim.o.tags = old_tags; return false end
      vim.schedule(function()
        vim.o.tags = tag_db
        vim.api.nvim_win_call(code_win, function()
          vim.cmd("tag " .. vim.fn.fnameescape(sym))
          vim.cmd("normal! zz")
        end)
        vim.notify("[jump:tags] " .. sym, vim.log.levels.INFO)
        vim.o.tags = old_tags
      end)
      return true
    end

    local function try_cscope()
      if not cscope_db then return false end
      if vim.fn.has("cscope") == 0 then return false end
      if vim.fn.cscope_connection(2, cscope_db) == 0 then
        pcall(vim.fn.cscope_add, cscope_db)
      end
      local ok, matches = pcall(vim.fn.cscope_find, "g", sym)
      if not ok or vim.tbl_isempty(matches) then return false end
      local m = matches[1]
      jump(m.filename, m.line, "cscope")
      return true
    end

    local esc = vim.pesc(sym)
    local patterns = {
      string.format([[^[\w\s\*\&]+?\b%s\s*\([^;{}]*\)\s*\{?]], esc),
      [[^\s*struct\s+]] .. esc .. [[\s*\{]],
      [[^\s*typedef\s+struct\s+]] .. esc .. [[\s*\{]],
      [[typedef\s+struct\s*\{[\s\S]*?\}\s*]] .. esc .. [[\s*;]],
      [[typedef\s+struct\s+\w+\s*\{[\s\S]*?\}\s*]] .. esc .. [[\s*;]],
      [[^\s*enum\s+]] .. esc .. [[\s*\{]],
      [[^\s*typedef\s+enum\s+]] .. esc .. [[\s*\{]],
      [[typedef\s+enum\s*\{[\s\S]*?\}\s*]] .. esc .. [[\s*;]],
      [[typedef\s+enum\s+\w+\s*\{[\s\S]*?\}\s*]] .. esc .. [[\s*;]],
      [[^\s*union\s+]] .. esc .. [[\s*\{]],
      [[typedef\s+union\s+\w+\s*\{[\s\S]*?\}\s*]] .. esc .. [[\s*;]],
      [[typedef\s+.*\(\s*\*\s*]] .. esc .. [[\s*\)\s*\(]],
      "^\\s*class\\s+" .. esc .. "\\s*[:{]",
      [[^\s*#\s*define\s+]] .. esc .. [[\b]],
    }

    local function try_rg()
      local tasks = {}
      for _, d in ipairs(rg_dirs) do
        for _, pat in ipairs(patterns) do
          table.insert(tasks, { dir = d, pat = pat })
        end
      end
      local idx = 1
      local stopped = false
      local function run_next()
        if stopped then return end
        local t = tasks[idx]
        if not t then
          vim.schedule(function() vim.notify("Definition not found: " .. sym, vim.log.levels.INFO) end)
          return
        end
        idx = idx + 1
        vim.system({
          "rg", "--multiline", "--multiline-dotall", "--line-number", "--no-heading", "--color=never",
          "--max-count", "1",
          "-g", "*.[ch]", "-g", "*.[ch]pp", "-g", "*.cc", "-g", "*.cpp", "-g", "*.cxx", "-g", "*.hpp",
          "-g", "!build", "-g", "!out", "-g", "!vendor",
          t.pat, t.dir,
        }, { text = true }, function(obj)
          if stopped then return end
          if obj.code == 0 and obj.stdout and obj.stdout ~= "" then
            local first = vim.split(obj.stdout, "\n", { trimempty = true })[1]
            local found_file, found_line = first:match("^([^:]+):(%d+):")
            if found_file then
              stopped = true
              jump(found_file, tonumber(found_line), "search")
              return
            end
          end
          run_next()
        end)
      end
      run_next()
    end

    if try_tags() then return end
    if try_cscope() then return end
    try_rg()
  end, { silent = true, desc = "[jump] tags -> cscope -> rg" })

  -- Maps 'gp' to visually select the last pasted/changed text block
  vim.keymap.set('n', 'gp', '`[v`]', { desc = "Select last pasted text" })
end

return M
