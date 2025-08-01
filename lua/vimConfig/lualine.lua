local M = { loaded = false }

local function quickfix_status()
    if vim.bo.filetype == 'qf' then
        return string.format('%d/%d', vim.fn.line('.'), vim.fn.line('$'))
    else
        local qflist = vim.fn.getqflist()
        local count = #qflist
        if count > 0 then
            return 'Q' .. count
        else
            return ''
        end
    end
end

local state = {
    refreshRate = 0,
    la_data = "",
}

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
            always_show_tabline = false,
            globalstatus = true, -- Unified statusline for all windows
        },
        sections = {
            lualine_a = {
                {
                    function()
                        -- Delay the refresh for this heavy cost
                        state.refreshRate = state.refreshRate + 1
                        local rem = state.refreshRate % 10
                        if rem ~= 0 and state.la_data ~= "" then
                            return state.la_data
                        end
                        state.refreshRate = 0

                        local function file_exists(filepath)
                            local ok, _ = os.rename(filepath, filepath)  -- Try renaming the file to itself
                            return ok and true or false
                        end

                        local is_docker = "/.dockerenv"
                        if file_exists(is_docker) then
                            state.la_data = "Container"
                            return state.la_data
                        else
                            -- tmux-info 'MN': M - session count; N - attched client count
                            local handle = io.popen(' [ -n "$TMUX_PANE" ] && tmux list-clients 2>/dev/null | wc -l || echo "_" ')
                            local ret = handle:read("*a")
                            handle:close()
                            local cli = ret:gsub("\n", "") ~= '' and ret:gsub("\n", "") or '_'

                            handle = io.popen(' [ -n "$TMUX_PANE" ] && tmux list-session 2>/dev/null | wc -l || echo "_" ')
                            local ret = handle:read("*a")
                            handle:close()
                            local ses = ret:gsub("\n", "") ~= '' and ret:gsub("\n", "") or '_'

                            state.la_data = ses .. cli
                            return state.la_data
                        end
                    end,
                    icon = '', -- Optional Nerd Font icon
                },
            },
            lualine_b = {
                {
                    'mode',
                    fmt = function(mode)
                        local buf_num = tostring(vim.api.nvim_get_current_buf())
                        local width = 4 -- Fixed width (example)
                        return mode:sub(1, width - #buf_num) .. buf_num
                    end,
                },
                { 'diff', symbols = { added = ' ', modified = ' ', removed = ' ' } },
                --[[ 'diagnostics', ]]
            },
            lualine_c = {
                { 'filename', path = 1, symbols = { modified = ' ●', readonly = ' ', unnamed = '[No Name]' },
                    cond = function()
                        -- Exclude these filetypes
                        local excluded = { 'qf', 'help', 'terminal', 'NvimTree' }
                        return not vim.tbl_contains(excluded, vim.bo.filetype)
                    end
                },
                {
                    function()
                        -- Get quickfix title
                        local title = vim.w.quickfix_title or vim.fn.getwinvar(vim.fn.win_getid(), 'quickfix_title')

                        -- Extract clean command (remove line count and pipe)
                        local command = title and title:gsub('|%d+ lines?$', ''):gsub('^:', '') or 'quickfix'

                        -- Add position info
                        return string.format('%s', command)
                    end
                }
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
        -- extensions = { 'quickfix', 'fugitive' }
        extensions = { 'fugitive' }

    }
end

return M

