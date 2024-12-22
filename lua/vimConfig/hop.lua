local M = { loaded = false }

function M.load()
    if M.loaded then
        return
    end
    M.loaded = true
    local plugExist = vim.fn['HasPlug']('hop.nvim') ~= 0
    if not plugExist then
        return
    end


    local opts = {
        keys = 'etovxqpdygfblzhckisuran'
    }

    require'hop'.setup(opts)
    local hop = require('hop')
    local directions = require('hop.hint').HintDirection
    vim.keymap.set('', 's', function()
        hop.hint_char1({ current_line_only = true })
        end, {remap=true})
    vim.keymap.set('', 'S', function()
        hop.hint_char1({})
        end, {remap=true})
end

return M

