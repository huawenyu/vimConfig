local M = { loaded = false }

function M.load()
    if M.loaded then
        return
    end
    M.loaded = true
    local plugExist = vim.fn['HasPlug']('todo-comments.nvim') ~= 0
    if not plugExist then
        return
    end


    require("todo-comments.config").setup{}
end

return M


