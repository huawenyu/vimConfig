-- local-autosession: Session management with auto-save/restore
local M = {}

function M.setup()
  local auto_session = require("auto-session")
  auto_session.setup({
    log_level = "error",
    root_dir = "/tmp/nvim-sessions",
    auto_restore_enabled = true,
    auto_save_enabled = true,
    auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
    auto_session_allowed_dirs = { "~/work", "~/workref" },
    session_lens = { load_on_setup = true, previewer = false },
  })

  vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

  local function default_workspace_name()
    local cwd = vim.fn.getcwd()
    local home = vim.loop.os_homedir()
    cwd = cwd:gsub("^" .. vim.pesc(home), "~")
    cwd = cwd:gsub("^~/", ""):gsub("[/\\]", "__")
    return cwd
  end

  local function save_workspace()
    vim.ui.input({
      prompt = "Workspace name: ",
      default = default_workspace_name(),
    }, function(input)
      if not input or input == "" then return end
      vim.cmd("AutoSession save " .. vim.fn.fnameescape(input))
      vim.notify("Saved workspace: " .. input, vim.log.levels.INFO)
    end)
  end

  local function project_session_search()
    vim.cmd("AutoSession search")
    vim.schedule(function()
      vim.fn.feedkeys(default_workspace_name(), "t")
    end)
  end

  vim.keymap.set("n", "<leader>ws", save_workspace, { desc = "[workspace] Save named workspace *" })
  vim.keymap.set("n", "<leader>wl", project_session_search, { desc = "[workspace] Search sessions *" })
  vim.keymap.set("n", "<leader>wr", "<cmd>AutoSession restore<CR>", { desc = "[workspace] Restore session *" })
end

return M
