-- vimconfig/autocmds.lua — Autocommands and commands (from conf_cmd.vim)
local M = {}

function M.setup()
  local g = vim.g

  -- Restore cursor to previous editing position
  if g.vim_confi_option.auto_restore_cursor then
    local function res_cur()
      if vim.fn.line("'\"") <= vim.fn.line("$") then
        vim.cmd("silent! normal! g`\"")
        return 1
      end
    end
    vim.api.nvim_create_autocmd("BufWinEnter", {
      callback = res_cur,
    })
  end

  local aug = vim.api.nvim_create_augroup("filetype_auto", { clear = true })

  vim.api.nvim_create_autocmd("TermClose", {
    group = aug,
    callback = function() vim.cmd([[echom "Normal:<C-\\n>; Insert: i"]]) end,
  })

  vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave" }, {
    group = aug,
    callback = function() vim.opt.cursorline = not vim.opt.cursorline:get() end,
  })

  vim.api.nvim_create_autocmd("VimResized", {
    group = aug,
    callback = function() vim.cmd("wincmd =") end,
  })

  vim.api.nvim_create_autocmd("CmdlineLeave", {
    group = aug,
    callback = function()
      vim.opt.cmdheight = 1
      local qflist = vim.fn.getqflist()
      if #qflist > 0 then
        pcall(vim.cmd, "silent! copen")
      end
    end,
  })

  vim.api.nvim_create_autocmd("CursorHold", {
    group = aug,
    callback = function() vim.cmd("normal! m'") end,
  })

  -- Always show sign column (legacy workaround)
  vim.api.nvim_create_autocmd("BufEnter", {
    group = aug,
    callback = function()
      vim.cmd("sign define dummy")
      vim.cmd("sign place 9999 line=1 name=dummy buffer=" .. vim.api.nvim_get_current_buf())
    end,
  })

  -- Filetype overrides
  vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    group = aug,
    pattern = { "*.c.rej", "*.c.orig", "*.h.rej", "*.h.orig", "patch.*", "*.diff", "*.patch" },
    callback = function() vim.bo.filetype = "diff"; vim.cmd("C4") end,
  })
  vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    group = aug,
    pattern = { "*.c", "*.h", "*.cpp", "*.C", "*.CXX", "*.CPP" },
    callback = function() vim.bo.filetype = "c" end,
  })

  vim.api.nvim_create_autocmd("TermOpen", {
    group = aug,
    callback = function() pcall(vim.cmd, "ContextDisable") end,
  })

  -- Forbidden filename check
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = aug,
    pattern = { [[[\,:;'"\]\)\}]*]] },
    callback = function() vim.notify("Forbidden file name: " .. vim.fn.expand("<afile>"), vim.log.levels.ERROR) end,
  })

  -- Keyword program per filetype
  if g.vim_confi_option.keywordprg_filetype then
    vim.api.nvim_create_autocmd("FileType", {
      group = aug,
      pattern = "python",
      callback = function() vim.bo.keywordprg = "pydoc" end,
    })
    vim.api.nvim_create_autocmd("FileType", {
      group = aug,
      pattern = "cpp",
      callback = function() vim.bo.keywordprg = ":te cppman" end,
    })
  end

  -- Indent style commands: C0, C2, C4, C8
  local style_cmds = {
    C0  = { tabstop = 4, shiftwidth = 4, softtabstop = 4, expandtab = true },
    C2  = { tabstop = 2, shiftwidth = 2, softtabstop = 2, expandtab = true },
    C02 = { tabstop = 2, shiftwidth = 2, softtabstop = 2, expandtab = true },
    C4  = { tabstop = 4, shiftwidth = 4, softtabstop = 4, expandtab = false },
    C04 = { tabstop = 4, shiftwidth = 4, softtabstop = 4, expandtab = true },
    C8  = { tabstop = 8, shiftwidth = 8, softtabstop = 8, expandtab = false },
    C08 = { tabstop = 8, shiftwidth = 8, softtabstop = 8, expandtab = true },
  }

  for name, opts in pairs(style_cmds) do
    vim.api.nvim_create_user_command(name, function()
      for k, v in pairs(opts) do
        vim.bo[k] = v
      end
      vim.bo.autoindent = true
      vim.bo.cindent = true
    end, { nargs = "*" })
  end
end

return M
