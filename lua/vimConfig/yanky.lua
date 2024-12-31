-- vim: :C0:

local M = { loaded = false }

-- Map, cmd-for-lazy-setup
function M.load()
    local plugExist = vim.fn['HasPlug']('yanky.nvim') ~= 0
    if not plugExist then
        M.loaded = true
        return
    end

    -- If the lua-plugin MUST call setup (itself lazy load), here expose a command to trigger the setup.
--[[     vim.api.nvim_create_user_command('LoadTodo', M.setup, {nargs=0})
   [
   [     local map = vim.api.nvim_set_keymap
   [     local opts = { noremap = true, silent = true }
   [     map('n', '<leader>vt', ':"(view)Todolist          theCommand"<c-U>TodoLocList<cr>', opts) ]]

    require("yanky").setup {
        ring = {
            history_length = 24,
            storage = "memory",
            storage_path = vim.fn.stdpath("data") .. "/databases/yanky.db", -- Only for sqlite storage
            sync_with_numbered_registers = true,
            cancel_event = "update",
            ignore_registers = { "_" },
            update_register_on_cycle = false,
            permanent_wrapper = nil,
        },
        picker = {
            select = {
                action = nil, -- nil to use default put action
            },
            telescope = {
                use_default_mappings = true, -- if default mappings should be used
                mappings = nil, -- nil to use default mappings or no mappings (see `use_default_mappings`)
            },
        },
        system_clipboard = {
            sync_with_ring = true,
            clipboard_register = nil,
        },
        highlight = {
            on_put = true,
            on_yank = true,
            timer = 500,
        },
        preserve_cursor_position = {
            enabled = true,
        },
        textobj = {
            enabled = true,
        },
    }

    -- require("telescope").load_extension("yank_history")
end


return M

