-- highlight symbol under cursor
-- see: https://github.com/Alexis12119/nvim-config/blob/77a9a7c2ab0c6e8e4d576d6987ee57e4c5540eee/configs/lsp/init.lua#L23-L44
-- note: updatetime controls when cursorhold events fire
local function lsp_highlight(client, bufnr)
    if client.supports_method("textDocument/documentHighlight") then
        vim.api.nvim_create_augroup("lsp_document_highlight", {
            clear = false,
        })
        vim.api.nvim_clear_autocmds({
            buffer = bufnr,
            group = "lsp_document_highlight",
        })
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            group = "lsp_document_highlight",
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            group = "lsp_document_highlight",
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
        })
    end
end

return {
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v3.x",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "neovim/nvim-lspconfig",
            "lvimuser/lsp-inlayhints.nvim",
            -- see https://github.com/rust-lang/rust.vim/issues/461
            "rust-lang/rust.vim",
        },
        config = function()
            local ih = require("lsp-inlayhints")
            ih.setup()
            local lsp_zero = require("lsp-zero")

            lsp_zero.on_attach(function(client, bufnr)
                ih.on_attach(client, bufnr)
                lsp_highlight(client, bufnr)

                -- see :help lsp-zero-keybindings
                lsp_zero.default_keymaps({
                    buffer = bufnr,
                    exclude = { "gi", "<F3>", "<F4>", "gr" },
                })

                local opts = { buffer = bufnr }
                -- vim.keymap.set({ "n", "v" }, "<leader>F", "<cmd>lua vim.lsp.buf.format()<cr>", opts)
                vim.keymap.set("n", "<leader>.", vim.lsp.buf.code_action, opts)
                vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, opts)
                vim.keymap.set("n", "<leader>ih", function()
                    require("lsp-inlayhints").toggle()
                end, opts)
            end)

            lsp_zero.set_sign_icons({
                error = "",
                warn = "",
                hint = "⚑",
                info = "",
            })

            -- see :help lsp-zero-guide:integrate-with-mason-nvim
            require("mason").setup({})
            require("mason-lspconfig").setup({
                ensure_installed = { "clangd", "lua_ls", "pyright", "rust_analyzer", "tsserver" },
                handlers = {
                    lsp_zero.default_setup,
                    -- fix lua lsp unknown global
                    lua_ls = function()
                        require("lspconfig").lua_ls.setup({
                            settings = {
                                Lua = {
                                    hint = {
                                        enable = true,
                                    },
                                    diagnostics = {
                                        enable = true,
                                        globals = { "vim" },
                                    },
                                },
                            },
                        })
                    end,
                },
            })
        end,
    },
}
