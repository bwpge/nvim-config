return {
    {
        "nvim-telescope/telescope.nvim",
        version = "*",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            defaults = {
                prompt_prefix = "   ",
                layout_strategy = "horizontal",
                sorting_strategy = "ascending",
                layout_config = {
                    horizontal = {
                        prompt_position = "top",
                        preview_width = 0.55,
                        results_width = 0.8,
                    },
                    vertical = {
                        mirror = false,
                    },
                    width = 0.87,
                    height = 0.75,
                },
                color_devicons = true,
            },
        },
    },
}
