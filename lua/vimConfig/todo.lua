local M = { loaded = false }

-- Map, cmd-for-lazy-setup
function M.load()
    local plugExist = vim.fn['HasPlug']('todo-comments.nvim') ~= 0
    if not plugExist then
        M.loaded = true
        return
    end

    -- If the lua-plugin MUST call setup (itself lazy load), here expose a command to trigger the setup.
    vim.api.nvim_create_user_command('LoadTodo', M.setup, {nargs=0})

    local map = vim.api.nvim_set_keymap
    local opts = { noremap = true, silent = true }
    map('n', '<leader>vl', ':"(view)Todolist          theCommand"<c-U>TodoLocList<cr>', opts)

end


-- lazy-setup, some plugin don't need it, for it auto-setup when vim-plug lazy load it by triggered 'on'-event.
function M.setup()
    if M.loaded then
        return
    end
    M.loaded = true

    require("todo-comments.config").setup{
        merge_keywords = false,
        keywords = {
            -- Define only your custom keywords
            MYTODO = { icon = "🐛",  color = "error", alt = { "TODO-" } },
            MYNOTE = { icon = "💡", color = "hint", alt = { "NOTE-" } },

            -- Redefine and "disable" default ones by assigning `false`
            FIX = nil,
            TODO = nil,
            HACK = nil,
            WARN = nil,
            PERF = nil,
            NOTE = nil,
            TEST = nil,
            BUG = nil,
        },
    }
end


return M

