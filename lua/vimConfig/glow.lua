local M = { loaded = false }

function M.load()
    if M.loaded then
        return
    end
    M.loaded = true
    local plugExist = vim.fn['HasPlug']('glow.nvim') ~= 0
    if not plugExist then
        return
    end

    vim.api.nvim_set_keymap('n', '<leader>vi',
        ':"(mode)Glow reader/present         "<c-U>Glow<CR>',
        { noremap=true, silent=true } )

    require('glow').setup {
        style = "dark",
        width = 120,
    }
end

return M

