return {
    {
        "stevearc/conform.nvim",
        event = "VeryLazy",
        opts = {
            formatters_by_ft = {
                go = { "gofumpt", "golines" },
                lua = { "stylua" },
                python = { "black", "isort" },
                ["_"] = { "trim_all" },
            },
            format_on_save = {
                timeout_ms = 5000,
                lsp_format = "fallback",
            },
        },
    },
}
