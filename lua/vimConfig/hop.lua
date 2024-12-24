local M = { loaded = false }

-- Map, cmd-for-lazy-setup
function M.load()
    local plugExist = vim.fn['HasPlug']('hop.nvim') ~= 0
    if not plugExist then
        M.loaded = true
        return
    end

    -- If the lua-plugin MUST call setup (itself lazy load), here expose a command to trigger the setup.
    vim.api.nvim_create_user_command('LoadHop', M.setup, {nargs=0})

    local map = vim.api.nvim_set_keymap
    local opts = { noremap = true, silent = true }
    map('n', ';s', ':HopChar1CurrentLine<cr>', opts)
    map('n', ';a', ':HopChar2<cr>', opts)
end


-- lazy-setup, some plugin don't need it, for it auto-setup when vim-plug lazy load it by triggered 'on'-event.
function M.setup()
    if M.loaded then
        return
    end
    M.loaded = true

    local opts = {
        keys = 'etovxqpdygfblzhckisuran'
    }

    require'hop'.setup(opts)
    --[[ local hop = require('hop')
       [ local directions = require('hop.hint').HintDirection
       [ vim.keymap.set('', ';s', function()
       [     hop.hint_char1({ current_line_only = true })
       [     end, {remap=true})
       [ vim.keymap.set('', ';a', function()
       [     hop.hint_char2({})
       [     end, {remap=true}) ]]
end


return M

