local utils = require("user.utils")
local kmap = utils.kmap
local nmap = utils.nmap

-- highlight symbol under cursor
-- see: https://github.com/Alexis12119/nvim-config/blob/77a9a7c2ab0c6e8e4d576d6987ee57e4c5540eee/configs/lsp/init.lua#L23-L44
-- vim.opt.updatetime controls when cursorhold events fire, but with
-- FixCursorHold plugin this uses vim.g.cursorhold_updatetime
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
            { "folke/neodev.nvim", opts = {} },
        },
        cmd = "Mason",
        event = "LazyFile",
        config = function()
            local ih = require("lsp-inlayhints")
            ih.setup()
            local lsp_zero = require("lsp-zero")

            lsp_zero.on_attach(function(client, bufnr)
                ih.on_attach(client, bufnr)
                lsp_highlight(client, bufnr)

                local opts = { buffer = bufnr or 0 }
                nmap("K", vim.lsp.buf.hover, "Hover documentation", opts)
                nmap("<leader>ih", ih.toggle, "Toggle inlay hints", opts)
                nmap("gd", require("telescope.builtin").lsp_definitions, "Go to definition", opts)
                nmap("gD", vim.lsp.buf.declaration, "Go to declaration", opts)
                -- stylua: ignore
                nmap("gm", require("telescope.builtin").lsp_implementations, "Go to implementation", opts)
                nmap("go", vim.lsp.buf.type_definition, "Go to type definition", opts)
                nmap("gr", require("telescope.builtin").lsp_references, "Go to reference", opts)
                nmap("gs", vim.lsp.buf.signature_help, "Show signature help", opts)
                kmap({ "n", "i" }, "<M-/>", vim.lsp.buf.signature_help, "Show signature help")
                nmap("<F2>", vim.lsp.buf.rename, "Rename symbol", opts)

                -- code actions
                nmap("<M-.>", vim.lsp.buf.code_action, "View code actions", opts)
                if vim.lsp.buf.range_code_action then
                    kmap("x", "<M-.>", vim.lsp.buf.range_code_action, "View code actions", opts)
                else
                    kmap("x", "<M-.>", vim.lsp.buf.code_action, "View code actions", opts)
                end

                -- diagnostics
                kmap("n", "gl", vim.diagnostic.open_float, "Show diagnostic", opts)
                kmap("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic", opts)
                kmap("n", "]d", vim.diagnostic.goto_next, "Next diagnostic", opts)
            end)

            lsp_zero.set_sign_icons({
                error = "",
                warn = "",
                info = "",
                hint = "󰌶",
            })

            -- see :help lsp-zero-guide:integrate-with-mason-nvim
            require("mason").setup({
                ui = {
                    icons = {
                        package_installed = "●",
                        package_pending = "●",
                        package_uninstalled = "●",
                    },
                },
            })
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "clangd",
                    "jsonls",
                    "lua_ls",
                    "gopls",
                    "pyright",
                    "rust_analyzer",
                    "taplo",
                    "tsserver",
                    "yamlls",
                },
                handlers = {
                    lsp_zero.default_setup,
                    lua_ls = function()
                        require("lspconfig").lua_ls.setup({
                            settings = {
                                Lua = {
                                    hint = {
                                        enable = true,
                                    },
                                    diagnostics = {
                                        enable = true,
                                    },
                                },
                            },
                        })
                    end,
                    rust_analyzer = function()
                        require("lspconfig").rust_analyzer.setup({
                            settings = {
                                ["rust-analyzer"] = {
                                    check = { command = "clippy" },
                                },
                            },
                        })
                    end,
                },
            })
        end,
    },
}
