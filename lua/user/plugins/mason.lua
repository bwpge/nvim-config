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
        opts = {
            ensure_installed = {
                "black",
                "clangd",
                "debugpy",
                "delve",
                "gofumpt",
                "golines",
                "gopls",
                "isort",
                "jsonls",
                "lua_ls",
                "prettier",
                "pyright",
                "rust_analyzer",
                "stylua",
                "taplo",
                "tsserver",
                "yamlls",
            },
            auto_update = false,
            run_on_start = false,
            integrations = {
                ["mason-lspconfig"] = true,
                ["mason-null-ls"] = false,
                ["mason-nvim-dap"] = true,
            },
        },
        config = function(_, opts)
            require("mason-tool-installer").setup(opts)

            -- install missing packages when loaded (allows lazy loading)
            require("mason-tool-installer").check_install(false)
        end,
    },
}
