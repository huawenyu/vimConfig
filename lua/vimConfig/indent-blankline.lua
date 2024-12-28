local M = { loaded = false }

-- Map, cmd-for-lazy-setup
function M.load()
    local plugExist = vim.fn['HasPlug']('indent-blankline.nvim') ~= 0
    if not plugExist then
        M.loaded = true
        return
    end

    require("ibl").setup() -- use default config
end


return M

