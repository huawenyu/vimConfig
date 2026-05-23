-- vimconfig/local.lua — General settings and highlight groups (from conf_local.vim)
local M = {}

function M.setup()
  local opt = vim.opt
  local g = vim.g

  -- History & completion
  opt.history = 5000
  opt.wildmode = { "list:longest", "list:full" }
  opt.wildignore:append("*.o,*.obj,.git,*.rbc,*.pyc,__pycache__,.idea,node_modules")
  opt.updatetime = 600
  opt.showcmd = false
  opt.shortmess:append("I") -- no intro message
  opt.shortmess:append("A") -- abbreviate messages
  opt.shortmess:append("F") -- "(file 1 of 2)" style
  opt.shortmess:append("O") -- overwrite message suppression
  opt.shortmess:append("c") -- no ins-completion-menu messages
  opt.shortmess:append("s") -- no "search hit BOTTOM" messages
  opt.shortmess:append("o") -- overwrite file-written message
  opt.cmdheight = 1

  -- Highlight groups
  vim.api.nvim_set_hl(0, "CursorLine", { fg = "NONE", bg = "NONE" })
  vim.api.nvim_set_hl(0, "Visual", { reverse = true, bg = "Grey" })
  vim.api.nvim_set_hl(0, "MatchParen", { bold = true, ctermbg = "none", ctermfg = "magenta" })
  vim.api.nvim_set_hl(0, "Search", { ctermfg = "Red", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "TabLine", { ctermfg = "DarkBlue", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "TabLineSel", { ctermfg = "Red", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "TabLineFill", { ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "NonText", { ctermfg = "DarkGrey", fg = "DarkGrey" })
  vim.api.nvim_set_hl(0, "SpecialKey", { link = "NonText" })

  -- Listchars
  if _G.HasNoPlug and _G.HasNoPlug("cyclist.vim") and _G.HasNoPlug("vim-listchars") and _G.HasNoPlug("vim-basic") then
    opt.listchars = "tab:» ,trail:~,extends:<,nbsp:."
  end

  -- Scroll performance
  opt.ttyfast = true
  opt.cursorline = false
  opt.synmaxcol = 128
  vim.cmd("syntax sync minlines=256")

  -- Tags
  opt.tagrelative = false
  opt.tags = "./tags,tags,.cache/tags,./.tags,.tags;"
end

return M
