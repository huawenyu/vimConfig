local M = { loaded = false }

function M.load()
    if M.loaded then
        return
    end
    M.loaded = true
    local plugExist = vim.fn['HasPlug']('fidget.nvim') ~= 0
    if not plugExist then
        return
    end


    require('fidget').setup {}
end

return M


