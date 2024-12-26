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
    map('n', '<leader>ve', ':"(view)Explore File           theCommand"<c-U>Neotree toggle<CR>', opts)
    map('n', '<leader>vf', ':"(view)Explore Focus          theCommand"<c-U>Neotree reveal<CR>', opts)
    map('n', '<leader>vb', ':"(view)Explore buffer         theCommand"<c-U>Neotree buffers<CR>', opts)
    map('n', '<leader>vg', ':"(view)Explore git            theCommand"<c-U>Neotree git<CR>', opts)
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
                indent_size = 2, -- Indentation size
                padding = 1, -- Extra padding on the left
                with_expanders = true, -- Add expanders near folders
            },
            icon = {
                folder_closed = "", -- Icon for closed folders
                folder_open = "", -- Icon for open folders
                folder_empty = "", -- Icon for empty folders
                default = "", -- Default file icon
            },
            git_status = {
                symbols = {
                    added = "✚", -- Added file
                    modified = "", -- Modified file
                    deleted = "", -- Deleted file
                    renamed = "➜", -- Renamed file
                    untracked = "★", -- Untracked file
                    ignored = "◌", -- Ignored file
                    unstaged = "✗", -- Unstaged changes
                    staged = "✓", -- Staged changes
                },
            },
        },
        filesystem = {
            auto_open = false,  -- Don't auto-close directories when opening files
            follow_current_file = true,
            close_folders_on_open = false,
            hijack_netrw = true,
            use_libuv_file_watcher = true,
            group_empty_dirs = true,
            default_component_configs = {},

            filtered_items = {
                visible = false, -- Toggle visibility of dotfiles with "H"
                hide_dotfiles = true, -- Hide dotfiles by default
                hide_gitignored = true, -- Hide files ignored by Git
                hide_by_name = { -- Hide specific files or folders
                    ".DS_Store", "thumbs.db",
                    "tags", '.tags', '.tagx', '.cscope.files', 'cscope.in.out','cscope.out','cscope.po.out',
                    '.jshintrc', '.jscsrc', '.eslintignore', '.eslintrc.json',
                    '.gitattributes', '.git',
                    '.ccls-cache', '.devops','.arcconfig','.vscode',
                },
            },
            follow_current_file = {
                enabled = true,
                leave_dirs_open = true,
            },
        },
        window = {
            mappings = {
                ["<TAB>"] = "toggle_node",
                ["z"] = "collapse_all", -- Use 'z' to collapse all nodes
                ["o"] = "open",
                ["O"] = function(state)
                    print("Pls expand_all by search: /*") -- Debug message
                end,
                ["<C-f>"] = "scroll_down", -- Scroll down by a page
                ["<C-b>"] = "scroll_up",   -- Scroll up by a page
            },
        },
    }
end


return M

