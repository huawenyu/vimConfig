local M = {}

-- Function to check if a directory exists
function M.isdirectory(path)
    local stat = vim.loop.fs_stat(path)
    return stat and stat.type == 'directory'
end

-- Function to create a directory
function M.mkdir(path)
    local mode = 493  -- This corresponds to 0755 in octal permissions
    vim.loop.fs_mkdir(path, mode)
end

-- Example usage
local path = "/path/to/directory"

if is_directory(path) then
    print(path .. " exists.")
else
    print(path .. " does not exist. Creating it now.")
    create_directory(path)
end

return M

