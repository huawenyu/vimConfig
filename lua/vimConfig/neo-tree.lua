local M = { loaded = false }

-- Map, cmd-for-lazy-setup
function M.load()
    local plugExist = vim.fn['HasPlug']('neo-tree.nvim') ~= 0
    if not plugExist then
        M.loaded = true
        return
    end

    -- If the lua-plugin MUST call setup (itself lazy load), here expose a command to trigger the setup.
    vim.api.nvim_create_user_command('LoadNeotree', M.setup, {nargs=0})

    local map = vim.api.nvim_set_keymap
    local opts = { noremap = true, silent = true }
    map('n', '<a-e><a-e>', ':"(view)Explore File           theCommand"<c-U>Neotree toggle<CR>', opts)
    map('n', '<a-e><a-f>', ':"(view)Explore Focus          theCommand"<c-U>Neotree reveal<CR>', opts)
    map('n', '<a-e><a-b>', ':"(view)Explore buffer         theCommand"<c-U>Neotree buffers<CR>', opts)
    map('n', '<a-e><a-g>', ':"(view)Explore git            theCommand"<c-U>Neotree git<CR>', opts)
end


-- lazy-setup, some plugin don't need it, for it auto-setup when vim-plug lazy load it by triggered 'on'-event.
function M.setup()
    if M.loaded then
        return
    end
    M.loaded = true

    -- Comment out for it's auto setup if sourced
    require("neo-tree").setup{
        default_component_configs = {
            indent = {
                indent_size = 2,
                padding = 1, -- Padding around file/directory names
            },
            name = {
                trailing_slash = false,
                use_git_status_colors = true,
            },
        },
        filesystem = {
            filtered_items = {
                visible = true, -- Show hidden files
            },
            follow_current_file = {
                enabled = true,
                leave_dirs_opsn = false, -- Close other dirs when following curr-file
            },
        },
        filtered_items = {
            visible = true, -- Show hidden files
        },
    }
end


return M

