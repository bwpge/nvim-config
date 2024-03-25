local utils = require("user.utils")

return {
    {
        "nvim-telescope/telescope.nvim",
        version = "*",
        dependencies = { "nvim-lua/plenary.nvim" },
        cmd = "Telescope",
        opts = utils.merge_custom_opts("telescope", {
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
                mappings = {
                    i = {
                        ["<esc>"] = "close",
                        ["<M-j>"] = "preview_scrolling_down",
                        ["<M-k>"] = "preview_scrolling_up",
                        ["<C-Home>"] = "move_to_top",
                        ["<C-End>"] = "move_to_bottom",
                    },
                },
            },
            pickers = {
                find_files = {
                    find_command = {
                        "rg",
                        "--files",
                        "--color",
                        "never",
                        "-uu",
                        "-g",
                        "!.git",
                        "-g",
                        "!node_modules",
                        "-g",
                        "!/target/",
                        "-g",
                        "!__pycache__",
                    },
                },
            },
        }),
    },
}
