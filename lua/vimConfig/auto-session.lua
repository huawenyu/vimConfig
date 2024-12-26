local M = { loaded = false }

-- Map, cmd-for-lazy-setup
function M.load()
    local plugExist = vim.fn['HasPlug']('auto-session') ~= 0
    if not plugExist then
        M.loaded = true
        return
    end

    -- If the lua-plugin MUST call setup (itself lazy load), here expose a command to trigger the setup.
    vim.api.nvim_create_user_command('LoadAutoSession', M.setup, {nargs=0})

    local map = vim.api.nvim_set_keymap
    local opts = { noremap = true, silent = false }
    map('n', '<leader>sr', ':"(Workspace)Restore          theCommand"<c-U>SessionRestore<cr>', opts)
    map('n', '<leader>ss', ':"(Workspace)Save             theCommand"<c-U>SessionSave<cr>', opts)
end


-- lazy-setup, some plugin don't need it, for it auto-setup when vim-plug lazy load it by triggered 'on'-event.
function M.setup()
    if M.loaded then
        return
    end
    M.loaded = true

    vim.g.auto_session_root_dir = vim.fn.expand('~/.vim/tmp-sessions')
    if not vim.fn.isdirectory(vim.g.auto_session_root_dir) then
        vim.fn.mkdir(vim.g.auto_session_root_dir, 'p')
    end
    -- vim.g.auto_session_pre_save_cmds = ['if exists(":NERDTreeClose") | exe "tabdo NERDTreeClose\<CR>" | endif']

    local opts = {
        log_level = 'error', -- info
        auto_save = true,
        auto_create = true,
        auto_restore = false, -- Enables/disables auto restoring session on start
        auto_restore_last_session = false, -- On startup, loads the last saved session if session for cwd does not existallowed_dirs = nil, -- Allow session restore/create in certain directories
        auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
        allowed_dirs = { "~/work", "~/workref" }, -- Allow session restore/create in certain directories
    }

    vim.o.sessionoptions="blank,buffers,curdir,folds,tabpages,winsize,winpos,terminal,localoptions"
    require('auto-session').setup(opts)
end


return M

