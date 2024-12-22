local M = { loaded = false }

function M.load()
    if M.loaded then
        return
    end
    M.loaded = true
    local plugExist = vim.fn['HasPlug']('auto-session') ~= 0
    if not plugExist then
        return
    end

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

