local M = { loaded = false }

-- Map, cmd-for-lazy-setup
function M.load()
    local plugExist = vim.fn['HasPlug']('symbols-outline.nvim') ~= 0
    if not plugExist then
        M.loaded = true
        return
    end

    -- If the lua-plugin MUST call setup (itself lazy load), here expose a command to trigger the setup.
    vim.api.nvim_create_user_command('LoadSymbolsOutline', M.setup, {nargs=0})

    local map = vim.api.nvim_set_keymap
    local opts = { noremap = true, silent = true }
    map('n', '<a-/>', ':"(view)LoadSymbolsOutline          theCommand"<c-U>SymbolsOutline<cr>', opts)
    map('n', '<leader>v/', ':"(view)LoadSymbolsOutline          theCommand"<c-U>SymbolsOutline<cr>', opts)

end


-- lazy-setup, some plugin don't need it, for it auto-setup when vim-plug lazy load it by triggered 'on'-event.
function M.setup()
    if M.loaded then
        return
    end
    M.loaded = true

    require("symbols-outline").setup{}
end


return M

