local M = { loaded = false }

function M.load()
    if M.loaded then
        return
    end
    M.loaded = true
    local plugExist = vim.fn['HasPlug']('edgy.nvim') ~= 0
    if not plugExist then
        return
    end

    require('edgy').setup {
        left = {
            {
                title = "Explore-legacy",
                ft = "nerdtree",
                pinned = false,
                open = "NERDTree",
                close = "NERDTreeClose",
                size = { height = 0.4 },
            },
            {
                title = "Functions",
                ft = "tagbar",
                pinned = false,
                open = "TagbarOpen",
                close = "TagbarClose",
                size = { height = 0.4 },
            },
            {
                title = "Explore-neo",
                ft = "neo-tree",
                pinned = false,
                filter = function(buf)
                    return vim.b[buf].neo_tree_source == "filesystem"
                end,
                size = { height = 0.4 },
            },
            {
                title = "Buffers",
                ft = "neo-tree",
                filter = function(buf)
                    return vim.b[buf].neo_tree_source == "buffers"
                end,
                pinned = true,
                collapsed = false, -- show window as closed/collapsed on start
                open = "Neotree position=top buffers",
                size = { height = 0.25 },
            },
            {
                title = "Git-status",
                ft = "neo-tree",
                filter = function(buf)
                    return vim.b[buf].neo_tree_source == "git_status"
                end,
                pinned = true,
                collapsed = false, -- show window as closed/collapsed on start
                open = "Neotree position=top git_status",
                size = { height = 0.25 },
            },
            {
                title = function()
                    local buf_name = vim.api.nvim_buf_get_name(0) or "[No Name]"
                    return vim.fn.fnamemodify(buf_name, ":t")
                end,
                ft = "Outline",
                pinned = false,
                open = "SymbolsOutlineOpen",
            },
            {
                title = "Outline",
                ft = "voomtree",
                pinned = false,
                open = "VoomToggle",
                size = { height = 0.5 },
            },

            -- any other neo-tree windows should also be here
            "neo-tree",
        },
        bottom = {
            -- toggleterm / lazyterm at the bottom with a height of 40% of the screen
            {
                ft = "toggleterm",
                size = { height = 0.4 },
                -- exclude floating windows
                filter = function(buf, win)
                    return vim.api.nvim_win_get_config(win).relative == ""
                end,
            },
            {
                ft = "lazyterm",
                title = "LazyTerm",
                size = { height = 0.4 },
                filter = function(buf)
                    return not vim.b[buf].lazyterm_cmd
                end,
            },
            "Trouble",
            {
                ft = "qf",
                buftype = 'quickfix',
                title = 'QuickFix',
                pinned = true,
            },
            {
                ft = "help",
                size = { height = 20 },
                -- only show help buffers
                filter = function(buf)
                    return vim.bo[buf].buftype == "help"
                end,
            },
            { ft = "spectre_panel", size = { height = 0.4 } },
        },

        open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "edgy" },
        -- edgebar animations
        animate = {
            enabled = false,
            fps = 100, -- frames per second
            cps = 120, -- cells per second
            on_begin = function()
                vim.g.minianimate_disable = true
            end,
            on_end = function()
                vim.g.minianimate_disable = false
            end,
            -- Spinner for pinned views that are loading.
            -- if you have noice.nvim installed, you can use any spinner from it, like:
            -- spinner = require("noice.util.spinners").spinners.circleFull,
            spinner = {
                frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
                interval = 80,
            },
        },
        -- enable this to exit Neovim when only edgy windows are left
        exit_when_last = false,
        -- close edgy when all windows are hidden instead of opening one of them
        -- disable to always keep at least one edgy split visible in each open section
        close_when_all_hidden = true,
        -- global window options for edgebar windows
        ---@type vim.wo
        wo = {
            -- Setting to `true`, will add an edgy winbar.
            -- Setting to `false`, won't set any winbar.
            -- Setting to a string, will set the winbar to that string.
            winbar = true,
            winfixwidth = true,
            winfixheight = false,
            winhighlight = "WinBar:EdgyWinBar,Normal:EdgyNormal",
            spell = false,
            signcolumn = "no",
        },
        icons = {
            closed = " ",
            open = " ",
        },
        -- enable this on Neovim <= 0.10.0 to properly fold edgebar windows.
        -- Not needed on a nightly build >= June 5, 2023.
        fix_win_height = vim.fn.has("nvim-0.10.0") == 0,
    }
end

return M

