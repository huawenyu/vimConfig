local M = { loaded = false }

local function quickfix_status()
    local qflist = vim.fn.getqflist()
    local count = #qflist
    if count > 0 then
        return 'Q' .. count
    else
        return ''
    end
end


function M.load()
    if M.loaded then
        return
    end
    M.loaded = true
    local plugExist = vim.fn['HasPlug']('lualine.nvim') ~= 0
    if not plugExist then
        return
    end


    require('lualine').setup {
        options = {
            icons_enabled = true,
            theme = 'auto', -- Replace with your preferred theme
            component_separators = { left = '⋮', right = '⋮'},
            section_separators = { left = '▌', right = '▐'}, -- 🔧   󰞯
            disabled_filetypes = {
                'tpipeline',
                statusline = {},
                winbar = {},
            },
            always_divide_middle = true,
            globalstatus = true, -- Unified statusline for all windows
        },
        sections = {
            lualine_a = {
                { 'mode', fmt = function(mode)
                        local handle1 = io.popen(' [ -n "$TMUX_PANE" ] && tmux list-clients 2>/dev/null | wc -l || echo "_" ')
                        local ret1 = handle1:read("*a")
                        handle1:close()
                        local r1 = ret1:gsub("\n", "") ~= '' and ret1:gsub("\n", "") or '_'

                        local handle2 = io.popen(' [ -n "$TMUX_PANE" ] && tmux list-session 2>/dev/null | wc -l || echo "_" ')
                        local ret2 = handle2:read("*a")
                        handle2:close()
                        local r2 = ret2:gsub("\n", "") ~= '' and ret2:gsub("\n", "") or '_'

                        local buf_num = tostring(vim.api.nvim_get_current_buf())
                        local width = 4 -- Fixed width (example)
                        return r2 .. r1 .. " " .. mode:sub(1, width - #buf_num) .. buf_num
                    end,
                    icon = '', -- Optional Nerd Font icon
                },
            },
            lualine_b = {
                { 'diff', symbols = { added = ' ', modified = ' ', removed = ' ' } },
                'diagnostics',
            },
            lualine_c = {
                { 'filename', path = 1, symbols = { modified = ' ●', readonly = ' ', unnamed = '[No Name]' } }
            },

            lualine_x = { 'branch', },
            lualine_y = { 'encoding', 'filetype', },
            lualine_z = {
                quickfix_status,
                'filesize',
                { 'location', fmt = function(location)
                        local width = 9 -- Set the desired width
                        if #location > width then
                            return location:sub(1, width - 1) .. '⋮' -- Truncate if too long
                        else
                            return string.rep(' ', width - #location) .. location -- Pad with spaces
                        end
                    end
                },
                'progress',
            },
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { 'filename' },
            lualine_x = { 'location' },
            lualine_y = {},
            lualine_z = {}
        },
        tabline = {}, -- Add tabline config if needed
        extensions = { 'quickfix', 'fugitive' }

    }
end

return M

