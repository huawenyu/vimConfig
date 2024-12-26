local M = { loaded = false }

-- Map, cmd-for-lazy-setup
function M.load()
    local plugExist = vim.fn['HasPlug']('nvim-window-picker') ~= 0
    if not plugExist then
        M.loaded = true
        return
    end

    vim.keymap.set("n", "<Leader>vs", function()
        local window_picker = require("window-picker")
        local picked_window_id = window_picker.pick_window({
            include_current = false, -- Exclude the current window
        })

        if picked_window_id then
            vim.api.nvim_set_current_win(picked_window_id)
        else
            print("No window selected")
        end
    end, { desc = "Pick and focus a window" })

    -- Set the highlight colors
    vim.api.nvim_set_hl(0, "WindowPicker", { fg = "#000000", bg = "#ffff00", bold = true })
    vim.api.nvim_set_hl(0, "WindowPickerNC", { fg = "#ffffff", bg = "#444444", bold = true })

    require("window-picker").setup{
        autoselect_one = true, -- Automatically select if there's only one window
        include_current = false, -- Exclude the current window from selection
        filter_rules = {
            bo = {
                filetype = { "NvimTree", "notify", }, -- Ignore these filetypes
            },
        },
        selection_display = function(char)
            return "<<< " .. char .. " >>>" -- Display window letters with brackets
        end,

        --[[ other_win_hl_color = "#ffff00", -- Yellow highlight for other windows
           [ use_winbar = true, -- Use the winbar instead of the statusline
           [ selection_hooks = {
           [     before_pick = function()
           [         vim.opt.laststatus = 0 -- Hide the statusline
           [     end,
           [     after_pick = function()
           [         vim.opt.laststatus = 2 -- Restore the statusline
           [     end,
           [ }, ]]
    }

end


return M

