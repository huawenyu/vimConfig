local M = { loaded = false }

function M.load()
    if M.loaded then
        return
    end
    M.loaded = true
    local plugExist = vim.fn['HasPlug']('cmp-nvim-lsp') ~= 0
    if not plugExist then
        return
    end

    local nvim_lsp = require('lspconfig')
    local on_attach = function(_, bufnr)
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        local opts = { noremap = true, silent = true }
        -- vim.api.nvim_buf_set_keymap(bufnr, 'n', ';fD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
        -- vim.api.nvim_buf_set_keymap(bufnr, 'n', ';fd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
        -- vim.api.nvim_buf_set_keymap(bufnr, 'n', ';fh', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
        -- vim.api.nvim_buf_set_keymap(bufnr, 'n', ';fH', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
        -- vim.api.nvim_buf_set_keymap(bufnr, 'n', ';fi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
        -- -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
        -- -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
        -- -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
        -- -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
        -- vim.api.nvim_buf_set_keymap(bufnr, 'n', ';fr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
        -- vim.api.nvim_buf_set_keymap(bufnr, 'n', ';fs', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
        -- -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
        -- -- vim.api.nvim_buf_set_keymap(bufnr, 'v', '<leader>ca', '<cmd>lua vim.lsp.buf.range_code_action()<CR>', opts)
        -- -- vim.api.nvim_buf_set_keymap(bufnr, 'n', ';fw', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
        -- vim.api.nvim_buf_set_keymap(bufnr, 'n', ';fn', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
        -- vim.api.nvim_buf_set_keymap(bufnr, 'n', ';fp', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
        -- vim.api.nvim_buf_set_keymap(bufnr, 'n', ';fq', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
        -- -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>so', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]], opts)

        vim.api.nvim_set_keymap('n', ';fD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
        vim.api.nvim_set_keymap('n', ';fd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
        vim.api.nvim_set_keymap('n', ';fh', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
        vim.api.nvim_set_keymap('n', ';fH', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
        vim.api.nvim_set_keymap('n', ';fi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
        vim.api.nvim_set_keymap('n', ';fr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
        vim.api.nvim_set_keymap('n', ';fs', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
        vim.api.nvim_set_keymap('n', ';fn', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
        vim.api.nvim_set_keymap('n', ';fp', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
        vim.api.nvim_set_keymap('n', ';fq', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

        vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
    end
    -- nvim-cmp supports additional completion capabilities
    local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

    -- Enable the following language servers
    -- local servers = { 'clangd', 'rust_analyzer', 'pyright', 'tsserver' }
    local servers = { 'clangd', 'rust_analyzer' }
    for _, lsp in ipairs(servers) do
        nvim_lsp[lsp].setup {
            on_attach = on_attach,
            capabilities = capabilities,
        }
    end
end

return M


