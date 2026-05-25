-- Shared git/yadm/yadme detection for diffview and gitsigns
local M = {}

function M.run_cmd_status(cmd)
  local success = os.execute(cmd .. " 2>/dev/null")
  return success == true or success == 0
end

function M.is_current_dir_tracked(binary)
  local cwd = vim.fn.getcwd()
  local cmd = string.format("%s ls-files %q  2>/dev/null | grep -q .", binary, cwd)
  return M.run_cmd_status(cmd)
end

function M.detect_git_cmd()
  local cwd = vim.fn.getcwd()
  local is_git_repo = vim.fn.isdirectory(cwd .. "/.git") == 1
  if is_git_repo then return "git" end
  if cwd == vim.env.HOME then return "yadm" end
  if M.is_current_dir_tracked("yadm") then return "yadm" end
  if M.is_current_dir_tracked("yadme") then return "yadme" end
  return "git"
end

return M
