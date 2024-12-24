local M = { loaded = false }

function M.load()
    if M.loaded then
        return
    end
    M.loaded = true
    local plugExist = vim.fn['HasPlug']('nvim-web-devicons') ~= 0
    if not plugExist then
        return
    end
end

function M.setup()
    require("nvim-web-devicons").setup {
        opts = {
            default = true, -- Enable default icons
        },
    }
end

return M
