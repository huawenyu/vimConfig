-- local-easyalign: Custom alignment delimiters for vim-easy-align
local M = {}

function M.setup()
  vim.g.easy_align_ignore_comment = 0
  vim.g.easy_align_delimiters = {
    [">"] = { pattern = ">>\\|=>\\|>" },
    ["/"] = { pattern = "//\\+\\|/\\*\\|\\*/", delimiter_align = "l", ignore_groups = { "!Comment" } },
    ["]"] = { pattern = "[[\\]]", left_margin = 0, right_margin = 0, stick_to_left = 0 },
    [")"] = { pattern = "[()]", left_margin = 0, right_margin = 0, stick_to_left = 0 },
    ['\\'] = { pattern = '\\\\$', left_margin = 1, stick_to_left = 0 },
    ['v'] = { pattern = [[\s\+\zs\*\?\w\+\s*\(;\|=\|(\)\@=]], left_margin = 1, right_margin = 0 },
    ['#'] = { pattern = [[#\s*define\s\+\zs\w\+]], left_margin = 1 },
    d = { pattern = " \\(\\S\\+\\s*[;=]\\)\\@=", left_margin = 0, right_margin = 0 },
    m = { pattern = "/\\\\$/", stick_to_left = 0, left_margin = 2, right_margin = 0 },
  }
end

return M
