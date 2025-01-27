-- vim: :C0:

local M = { loaded = false }

-- Map, cmd-for-lazy-setup
function M.load()
    local plugExist = vim.fn['HasPlug']('nvim-FeMaco.lua') ~= 0
    if not plugExist then
        M.loaded = true
        return
    end

    -- If the lua-plugin MUST call setup (itself lazy load), here expose a command to trigger the setup.
    vim.api.nvim_create_user_command('LoadFeMaco', M.setup, {nargs=0})

    local map = vim.api.nvim_set_keymap
    local opts = { noremap = true, silent = true }
    map('n', '<leader>ei', ':"(edit)FenceCode          theCommand"<c-U>FeMaco<cr>', opts)

end


-- lazy-setup, some plugin don't need it, for it auto-setup when vim-plug lazy load it by triggered 'on'-event.
function M.setup()
    if M.loaded then
        return
    end
    M.loaded = true

    require('femaco').setup{}
end


return M

