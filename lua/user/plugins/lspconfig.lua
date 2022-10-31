local lspconfig = require('user.core.utils').require_plugin('lspconfig')
if not lspconfig then return end

local km = vim.keymap

-- see: https://github.com/neovim/nvim-lspconfig#suggested-configuration
local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr }

    -- lspsaga keymaps
    km.set('n', '<leader>lf', '<cmd>Lspsaga lsp_finder<cr>', bufopts)
    km.set('n', '<leader>ld', '<cmd>Lspsaga peek_definition<cr>', bufopts)
    km.set({ 'n', 'v' }, '<leader>a', '<cmd>Lspsaga code_action<cr>', bufopts)
    km.set('n', '<leader>lr', '<cmd>Lspsaga rename<cr>', bufopts)
    km.set('n', '<F2>', '<cmd>Lspsaga rename<cr>', bufopts)
    km.set('n', '<leader>d', '<cmd>Lspsaga show_line_diagnostics<cr>', bufopts)
    km.set('n', '<leader>d', '<cmd>Lspsaga show_cursor_diagnostics<cr>', bufopts)
    km.set('n', '[d', '<cmd>Lspsaga diagnostic_jump_prev<cr>', bufopts)
    km.set('n', ']d', '<cmd>Lspsaga diagnostic_jump_next<cr>', bufopts)
    km.set('n', '<leader>li', '<cmd>Lspsaga hover_doc<cr>', bufopts)
    km.set('n', '<leader>lo', '<cmd>LSoutlineToggle<cr>', bufopts)

    -- lspconfig keymaps
    km.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    km.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    km.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    km.set('n', 'gr', vim.lsp.buf.references, bufopts)
    -- km.set('n', '<space>a', vim.lsp.buf.code_action, bufopts)
    km.set('n', '<F12>', vim.lsp.buf.definition, bufopts)
    -- km.set('n', '<F2>', vim.lsp.buf.rename, bufopts)
    km.set('n', '<leader>kf', function() vim.lsp.buf.format { async = true } end, bufopts)
end

local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if not cmp_nvim_lsp_status then
    error('Could not load cmp_nvim_lsp!')
    return
end


local lsp_flags = {
    debounce_text_changes = 150,
}

local capabilities = cmp_nvim_lsp.default_capabilities()

-- configure rust-analyzer
lspconfig['rust_analyzer'].setup({
    on_attach = on_attach,
    capabilities = capabilities,
    flags = lsp_flags,
    settings = {
        ["rust-analyzer"] = {
            cargo = {
                allFeatures = true,
            },
            completion = {
                postfix = {
                    enable = false,
                },
            },
        }
    },
})

-- configure lua-language-server
lspconfig['sumneko_lua'].setup({
    on_attach = on_attach,
    capabilities = capabilities,
    flags = lsp_flags,
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT' },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { 'vim' },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = {
                    [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                    [vim.fn.stdpath('config') .. '/lua'] = true,
                    -- vim.api.nvim_get_runtime_file('', true),
                },
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
})

-- configure lsp diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    signs = true,
    update_in_insert = true,
}
)
