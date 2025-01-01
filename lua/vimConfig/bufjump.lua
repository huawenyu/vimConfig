-- vim: :C0:

local M = { loaded = false }

-- Map, cmd-for-lazy-setup
function M.load()
    local plugExist = vim.fn['HasPlug']('bufjump.nvim') ~= 0
    if not plugExist then
        M.loaded = true
        return
    end

    --[[ local map = vim.api.nvim_set_keymap
       [ local opts = { noremap = true, silent = true }
       [ map("n", "<M-o>", ":lua require('bufjump').backward()<cr>", opts)
       [ map("n", "<M-i>", ":lua require('bufjump').forward()<cr>", opts)
       [ -- map("n", "<M-o>", ":lua require('bufjump').backward_same_buf()<cr>", opts)
       [ -- map("n", "<M-i>", ":lua require('bufjump').forward_same_buf()<cr>", opts) ]]

    require("bufjump").setup{
        forward_key = ";i",
        backward_key = ";o",
        on_success = function()
            vim.cmd([[execute "normal! g`\"zz"]])
        end,
    }
end


return M

