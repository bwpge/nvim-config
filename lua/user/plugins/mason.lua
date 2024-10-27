local U = require("user.utils")

return {
    {
        "williamboman/mason.nvim",
        lazy = false,
        keys = {
            { "<leader>pm", "<cmd>Mason<cr>", desc = "Open Mason status window" },
        },
        opts = {
            ui = {
                icons = {
                    package_installed = "●",
                    package_pending = "●",
                    package_uninstalled = "●",
                },
            },
        },
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        cmd = { "MasonToolsInstall", "MasonToolsUpdate" },
        dependencies = { "mason.nvim" },
        event = "LazyFile",
        opts = function()
            local ensure_installed = {
                "clangd",
                "lua_ls",
                "rust_analyzer",
                "stylua",
                "taplo",
            }

            local pkgs = {
                python = {
                    exe = { "python", "python3" },
                    "black",
                    "debugpy",
                    "isort",
                    "jedi_language_server",
                    "pylsp",
                },
                go = {
                    "delve",
                    "gofumpt",
                    "golines",
                    "gopls",
                    "staticcheck",
                },
                npm = {
                    "ts_ls",
                    "prettier",
                    "jsonls",
                    "yamlls",
                },
            }

            -- only add mason packages that have required language tools
            for k, v in pairs(pkgs) do
                local has_exe = U.any(vim.tbl_map(function(x)
                    return vim.fn.executable(x) == 1
                end, v.exe or { k }))

                if has_exe then
                    for _, pkg in ipairs(v) do
                        table.insert(ensure_installed, pkg)
                    end
                end
            end

            return {
                ensure_installed = ensure_installed,
                auto_update = false,
                run_on_start = false,
                integrations = {
                    ["mason-lspconfig"] = true,
                    ["mason-null-ls"] = false,
                    ["mason-nvim-dap"] = true,
                },
            }
        end,
        config = function(_, opts)
            require("mason-tool-installer").setup(opts)

            -- install missing packages when loaded (allows lazy loading)
            require("mason-tool-installer").check_install(false)
        end,
    },
}
