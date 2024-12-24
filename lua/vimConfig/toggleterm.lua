local M = { loaded = false }

-- Map, cmd-for-lazy-setup
function M.load()
    local plugExist = vim.fn['HasPlug']('toggleterm.nvim') ~= 0
    if not plugExist then
        M.loaded = true
        return
    end

    -- If the lua-plugin MUST call setup (itself lazy load), here expose a command to trigger the setup.
    vim.api.nvim_create_user_command('LoadToggleTerm', M.setup, {nargs=0})

    local map = vim.api.nvim_set_keymap
    local opts = { noremap = true, silent = true }
    map('n', '<c-\\>', ':"(view)Terminal          theCommand"<c-U>TermToggle<cr>', opts)

end


-- lazy-setup, some plugin don't need it, for it auto-setup when vim-plug lazy load it by triggered 'on'-event.
function M.setup()
    if M.loaded then
        return
    end
    M.loaded = true

    require("toggleterm").setup {
        close_on_exit = true, -- close the terminal window when the process exits
         -- Change the default shell. Can be a string or a function returning a string
        shell = '/bin/bash',
        auto_scroll = true, -- automatically scroll to the bottom on terminal output
        start_in_insert = true,
        open_mapping = [[<c-\>]],
        terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
        persist_size = false,
        persist_mode = false, -- if set to true (default) the previous terminal mode will be remembered
        close_on_exit = true, -- close the terminal window when the process exits
        shell = '/bin/bash',
    }

    -- require("toggleterm").setup{
    --     open_mapping = [[<c-\>]],
    --     hide_numbers = true, -- hide the number column in toggleterm buffers
    --     shade_filetypes = {},
    --     autochdir = false, -- when neovim changes it current directory the terminal will change it's own when next it's opened
    --     shade_terminals = true, -- NOTE: this option takes priority over highlights specified so if you specify Normal highlights you should set this to false
    --     start_in_insert = true,
    --     insert_mappings = true, -- whether or not the open mapping applies in insert mode
    --     terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
    --     persist_size = true,
    --     persist_mode = true, -- if set to true (default) the previous terminal mode will be remembered
    --     close_on_exit = true, -- close the terminal window when the process exits
    --      -- Change the default shell. Can be a string or a function returning a string
    --     shell = '/bin/bash',
    --     auto_scroll = true, -- automatically scroll to the bottom on terminal output
    --     winbar = {
    --       enabled = false,
    --     },
    -- }
end


return M

