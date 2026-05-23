-- vimconfig/ftplugin.lua — Filetype-specific settings (from after/ftplugin/ and after/syntax/)
local M = {}

function M.setup()
  -- JSON comment syntax highlighting
  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.json",
    callback = function()
      vim.cmd([[syn region jsonComment start="/\*" end="\*/"]])
      vim.api.nvim_set_hl(0, "jsonCommentError", { link = "Comment" })
      vim.api.nvim_set_hl(0, "jsonComment", { link = "Comment" })
    end,
  })
end

return M
