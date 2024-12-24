local M = { loaded = false }

-- Map, cmd-for-lazy-setup
function M.load()
    local plugExist = vim.fn['HasPlug']('glow.nvim') ~= 0
    if not plugExist then
        M.loaded = true
        return
    end

    -- If the lua-plugin MUST call setup (itself lazy load), here expose a command to trigger the setup.
    vim.api.nvim_create_user_command('LoadGlow', M.setup, {nargs=0})


    local map = vim.api.nvim_set_keymap
    local opts = { noremap = true, silent = true }
    -- Why trigger TodoLocList twice:
    --   the 1st call: let vim-plug load the real plugin, for we lazy-load this plug by vim-plug 'on': TodoLocList
    --   the 2nd call: plugin.setup()
    --   the 3rd call: really execute the command
    --   Then remap this same key in our setup
    -- Why `12theCommand`
    --   12 - step 1 out of whole 2 steps
    --   `theCommand`:
    --     + help search all our key map, 
    --     + hide the real cmd from which-key hints
    map('n', '<leader>vi', ':"(mode)Glow reader/present         12theCommand"<c-U>exec \'silent! Glow\' | exec \'LoadGlow\' | Glow<cr>', opts)

end


-- lazy-setup, some plugin don't need it, for it auto-setup when vim-plug lazy load it by triggered 'on'-event.
function M.setup()
    if M.loaded then
        return
    end
    M.loaded = true

    local map = vim.api.nvim_set_keymap
    local opts = { noremap = true, silent = true }
    map('n', '<leader>vi', ':"(mode)Glow reader/present         22theCommand"<c-U>Glow<cr>', opts)

    require('glow').setup {
        style = "dark",
        width = 120,
    }
end


return M




