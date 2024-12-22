local M = { loaded = false }

function M.load()
    if M.loaded then
        return
    end
    M.loaded = true
    local plugExist = vim.fn['HasPlug']('fzf-lsp.nvim') ~= 0
    if not plugExist then
        return
    end

    local nvim_lsp = require('lspconfig')
    -- nvim-cmp supports additional completion capabilities
    local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

    -- Enable the following language servers
    -- local servers = { 'clangd', 'rust_analyzer', 'pyright', 'tsserver' }
    local servers = { 'clangd', 'rust_analyzer' }
    for _, lsp in ipairs(servers) do
        nvim_lsp[lsp].setup {
            capabilities = capabilities,
        }
    end
end

return M


