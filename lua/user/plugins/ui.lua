return {
    {
        "stevearc/dressing.nvim",
        event = "VeryLazy",
    },
    {
        "j-hui/fidget.nvim",
        opts = {
            progress = {
                display = {
                    done_icon = "",
                    done_style = "DiagnosticOk",
                },
            },
        },
    },
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        event = "VeryLazy",
        opts = {
            height = 15,
            use_diagnostic_signs = true,
        },
    },
}
