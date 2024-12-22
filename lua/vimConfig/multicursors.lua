local M = { loaded = false }

function M.load()
    if M.loaded then
        return
    end
    M.loaded = true
    local plugExist = vim.fn['HasPlug']('multicursors.nvim') ~= 0
    if not plugExist then
        return
    end


    require('multicursors').setup {
        normal_keys = {
            -- to change default lhs of key mapping change the key
            [','] = {
                -- assigning nil to method exits from multi cursor mode
                -- assigning false to method removes the binding
                method = N.clear_others,
                -- you can pass :map-arguments here
                opts = { desc = 'Clear others' },
            },
            ['<C-d>'] = {
                method = function()
                    require('multicursors.utils').call_on_selections(function(selection)
                        vim.api.nvim_win_set_cursor(0, { selection.row + 1, selection.col + 1 })
                        local line_count = selection.end_row - selection.row + 1
                        vim.cmd('normal ' .. line_count .. 'gcc')
                    end)
                end,
                opts = { desc = 'comment selections' },
            },
        },
    }
end

return M


