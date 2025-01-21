-- vim: :C0:

local M = { loaded = false }

-- Map, cmd-for-lazy-setup
function M.load()
    local plugExist = vim.fn['HasPlug']('telescope.nvim') ~= 0
    if not plugExist then
        M.loaded = true
        return
    end

    local telescope = require("telescope")
    telescope.setup{
        defaults = {
            layout_config = {
                scroll_speed = 2,  -- Adjust this value to set the number of lines to scroll
            },
            mappings = {
                i = {
                    ["<a-p>"] = require('telescope.actions').preview_scrolling_up,
                    ["<a-n>"] = require('telescope.actions').preview_scrolling_down,

                    -- IMPORTANT
                    -- either hot-reloaded or `function(prompt_bufnr) telescope.extensions.hop.hop end`
                    --[[ ['<C-h>'] = function(prompt_bufnr)
                       [     require('telescope').extensions.hop.hop(prompt_bufnr)
                       [ end, ]]
                    [';;'] = function(prompt_bufnr)
                        require('telescope').extensions.hop.hop(prompt_bufnr)
                    end,
                },
                n = {
                    ["<a-p>"] = require('telescope.actions').preview_scrolling_up,
                    ["<a-n>"] = require('telescope.actions').preview_scrolling_down,
                },
            },
        },
        extensions = {
            fzf = {
                fuzzy = true,                    -- false will only do exact matching
                override_generic_sorter = true,  -- override the generic sorter
                override_file_sorter = true,     -- override the file sorter
                case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                -- the default case_mode is "smart_case"
            },
            hop = {
                -- the shown `keys` are the defaults, no need to set `keys` if defaults work for you ;)
                keys = {"a", "s", "d", "f", "g", "h", "j", "k", "l", ";",
                "q", "w", "e", "r", "t", "y", "u", "i", "o", "p", },
                -- Highlight groups to link to signs and lines; the below configuration refers to demo
                -- sign_hl typically only defines foreground to possibly be combined with line_hl
                sign_hl = { "WarningMsg", "Title" },
                -- optional, typically a table of two highlight groups that are alternated between
                line_hl = { "CursorLine", "Normal" },
                -- options specific to `hop_loop`
                -- true temporarily disables Telescope selection highlighting
                clear_selection_hl = false,
                -- highlight hopped to entry with telescope selection highlight
                -- note: mutually exclusive with `clear_selection_hl`
                trace_entry = true,
                -- jump to entry where hoop loop was started from
                reset_selection = true,
            },
        }
    }

    telescope.load_extension('fzf')
    telescope.load_extension('hop')
end

return M

