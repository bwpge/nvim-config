local U = require("user.utils")
local kmap = U.kmap
local nmap = U.nmap

---Toggles native inlay hints.
local function toggle_inlay_hints()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end

return {
    {
        "folke/lazydev.nvim",
        dependencies = { "Bilal2453/luvit-meta" },
        event = "LazyProject:nvim",
        opts = {
            library = { "luvit-meta/library" },
        },
    },
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v3.x",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "neovim/nvim-lspconfig",
            "ray-x/lsp_signature.nvim",
            -- see https://github.com/rust-lang/rust.vim/issues/461
            "rust-lang/rust.vim",
        },
        event = "LazyFile",
        keys = {
            U.lazy_nmap("<leader>lr", "<cmd>LspRestart<cr>", "Restart attached LSPs"),
            U.lazy_nmap("<leader>li", "<cmd>LspInfo<cr>", "Show info about attached LSPs"),
        },
        config = function()
            local lsp_zero = require("lsp-zero")

            lsp_zero.on_attach(function(_, bufnr)
                require("lsp_signature").on_attach({
                    bind = true,
                    doc_lines = 0,
                    hi_parameter = "IncSearch",
                    hint_enable = false,
                }, bufnr)
                vim.lsp.inlay_hint.enable()

                local opts = { buffer = bufnr or 0 }
                nmap("<leader>ih", toggle_inlay_hints, "Toggle inlay hints", opts)
                nmap("gd", require("telescope.builtin").lsp_definitions, "Go to definition", opts)
                nmap("gD", vim.lsp.buf.declaration, "Go to declaration", opts)
                -- stylua: ignore
                nmap("gm", require("telescope.builtin").lsp_implementations, "Go to implementation", opts)
                nmap("go", vim.lsp.buf.type_definition, "Go to type definition", opts)
                kmap({ "n", "i" }, "<M-/>", vim.lsp.buf.signature_help, "Show signature help")
                nmap("<F2>", vim.lsp.buf.rename, "Rename symbol", opts)
                nmap("grn", vim.lsp.buf.rename, "Rename symbol", opts)
                nmap("grr", require("telescope.builtin").lsp_references, "Go to reference", opts)

                -- code actions
                kmap({ "n", "i" }, "<M-.>", vim.lsp.buf.code_action, "View code actions", opts)
                if vim.lsp.buf.range_code_action then
                    kmap("x", "<M-.>", vim.lsp.buf.range_code_action, "View code actions", opts)
                else
                    kmap("x", "<M-.>", vim.lsp.buf.code_action, "View code actions", opts)
                end
            end)

            lsp_zero.set_sign_icons({
                error = "",
                warn = "",
                info = "",
                hint = "󰌶",
            })

            -- mason must be configured before mason-lspconfig
            -- (it should be since it is not lazy loaded)
            if not require("mason").has_setup then
                U.notify_error("mason was not setup before mason-lspconfig")
                return
            end

            -- simple wrapper to clean up nesting levels
            local function server_config(name, opts, inner)
                if not inner then
                    inner = name
                end
                return function()
                    require("lspconfig")[name].setup({
                        settings = {
                            [inner] = opts,
                        },
                    })
                end
            end

            require("mason-lspconfig").setup({
                handlers = {
                    clangd = require("lspconfig").clangd.setup({
                        cmd = {
                            "clangd",
                            "--background-index",
                            "--header-insertion=never",
                            "--compile-commands-dir=build",
                            "--pch-storage=memory",
                            "--clang-tidy",
                        },
                    }),
                    lsp_zero.default_setup,
                    lua_ls = server_config("lua_ls", {
                        hint = {
                            enable = true,
                        },
                        diagnostics = {
                            enable = true,
                        },
                    }, "Lua"),
                    gopls = server_config("gopls", {
                        staticcheck = true,
                        analyses = {
                            unusedparams = true,
                            unusedvariable = true,
                            unusedresult = true,
                        },
                    }),
                    pylsp = server_config("pylsp", {
                        plugins = {
                            pycodestyle = {
                                enabled = true,
                                ignore = { "E501", "E231" },
                                maxLineLength = 120,
                            },
                        },
                    }),
                    rust_analyzer = server_config("rust_analyzer", {
                        check = { command = "clippy" },
                    }, "rust-analyzer"),
                },
            })
        end,
    },
}
