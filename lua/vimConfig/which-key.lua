local M = { loaded = false }

function M.load()
    if M.loaded then
        return
    end
    M.loaded = true
    local plugExist = vim.fn['HasPlug']('which-key.nvim') ~= 0
    if not plugExist then
        return
    end


    require("which-key").setup {
        plugins = {
            marks = false,
            registers = false,
            spelling = {
                enabled = false, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
                suggestions = 20, -- how many suggestions should be shown in the list?
            },
            -- the presets plugin, adds help for a bunch of default keybindings in Neovim
            -- No actual key bindings are created
            presets = {
                operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
                motions = false, -- adds help for motions
                text_objects = false, -- help for text objects triggered after entering an operator
                windows = true, -- default bindings on <c-w>
                nav = true, -- misc bindings to work with windows
                z = true, -- bindings for folds, spelling and others prefixed with z
                g = true, -- bindings for prefixed with g
            },
        },
        delay = 700,
        icons = {
            -- breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
            -- separator = "░", -- symbol used between a key and it's label
            -- group = "▶", -- symbol prepended to a group
        },
        layout = {
            height = { min = 4, max = 25 }, -- min and max height of the columns
            width = { min = 20, max = 40 }, -- min and max width of the columns
            spacing = 4, -- spacing between columns
            align = "left", -- align columns left, center or right
        },
    }
end

return M

