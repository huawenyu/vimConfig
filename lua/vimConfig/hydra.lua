local M = { loaded = false }

function M.load()
    if M.loaded then
        return
    end
    M.loaded = true
    local plugExist = vim.fn['HasPlug']('hydra.nvim') ~= 0
    if not plugExist then
        return
    end


    require('hydra').setup {
        debug = false,
        exit = false,
        foreign_keys = nil,
        color = "red",
        timeout = false,
        invoke_on_body = false,
        hint = {
            show_name = true,
            position = { "bottom" },
            offset = 0,
            float_opts = { },
        },
        on_enter = nil,
        on_exit = nil,
        on_key = nil,
    }
end

return M

