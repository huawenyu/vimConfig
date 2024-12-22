local M = { loaded = false }

function M.load()
    if M.loaded then
        return
    end
    M.loaded = true
    local plugExist = vim.fn['HasPlug']('neo-tree.nvim') ~= 0
    if not plugExist then
        return
    end


    require('neo-tree').setup({
        renderer = {
            icons = true,
        },
        window = {
            mappings = {
                ["O"] = expand_all_nodes,
            },
        },
    })
end

return M

