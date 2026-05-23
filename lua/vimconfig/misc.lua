-- vimconfig/misc.lua — Utility functions (from autoload/vconf/misc.vim)
local M = {}

function M.mark_exist(mark)
  local pos = vim.fn.getpos("'" .. mark)
  return pos[1] > 0 and 1 or 0
end

return M
