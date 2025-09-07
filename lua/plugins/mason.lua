local U = require("config.utils")

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
        dependencies = {
            "mason.nvim",
            "neovim/nvim-lspconfig",
        },
        event = "LazyFile",
        opts = function()
            local ensure_installed = {
                "lua-language-server",
                "stylua",
            }

            local pkgs = {
                cargo = {
                    -- these don't need cargo to install, but are mainly for rust development
                    "rust-analyzer",
                    "taplo",
                },
                npm = {
                    "typescript-language-server",
                    "prettier",
                    "json-lsp",
                    "yaml-language-server",
                },
                python = {
                    exe = { "python", "python3" },
                    "black",
                    "debugpy",
                    "isort",
                    "jedi-language-server",
                    "python-lsp-server",
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
                run_on_start = false, -- lazy load in config
                integrations = {
                    ["mason-lspconfig"] = true,
                    ["mason-null-ls"] = false,
                    ["mason-nvim-dap"] = true,
                },
            }
        end,
        config = function(_, opts)
            local mti = require("mason-tool-installer")
            mti.setup(opts)

            -- use mason registry to get lsp configuration names
            local lsp_map = {}
            for _, pkg_spec in ipairs(require("mason-registry").get_all_package_specs()) do
                local lsp_name = vim.tbl_get(pkg_spec, "neovim", "lspconfig")
                if lsp_name then
                    lsp_map[pkg_spec.name] = lsp_name
                end
            end

            -- enable servers after updates
            vim.api.nvim_create_autocmd("User", {
                pattern = "MasonToolsUpdateCompleted",
                callback = function(e)
                    local data = vim.iter(e.data)
                        :map(function(v)
                            return lsp_map[v]
                        end)
                        :filter(function(v)
                            return v ~= nil
                        end)
                        :totable()

                    vim.schedule(function()
                        vim.lsp.enable(data)
                    end)
                end,
            })

            -- install missing packages when loaded (allows lazy loading)
            mti.check_install(false)

            -- collect servers that are already installed
            local installed_lsp = {}
            for _, pkg_name in ipairs(require("mason-registry").get_installed_package_names()) do
                local name = lsp_map[pkg_name]
                if name then
                    table.insert(installed_lsp, name)
                end
            end

            -- enable installed servers
            if #installed_lsp > 0 then
                vim.schedule(function()
                    vim.lsp.enable(installed_lsp)
                end)
            end
        end,
    },
}
