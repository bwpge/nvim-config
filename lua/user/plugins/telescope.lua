local utils = require("user.utils")

local open_with_trouble = function(...)
    return require("trouble.providers.telescope").open_with_trouble(...)
end
local open_selected_with_trouble = function(...)
    return require("trouble.providers.telescope").open_selected_with_trouble(...)
end

local function get_make_cmd()
    if vim.fn.executable("make") == 1 then
        return "make"
    elseif vim.fn.executable("cmake") == 1 then
        return "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build"
    end
end
local make_cmd = get_make_cmd()

return {
    {
        "nvim-telescope/telescope.nvim",
        version = "*",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = make_cmd },
        },
        cmd = "Telescope",
        opts = utils.merge_custom_opts("telescope", {
            defaults = {
                selection_caret = " ",
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
                        ["<C-Down>"] = "preview_scrolling_down",
                        ["<C-Up>"] = "preview_scrolling_up",
                        ["<M-Down>"] = "cycle_history_next",
                        ["<M-Up>"] = "cycle_history_prev",
                        ["<C-Home>"] = "move_to_top",
                        ["<C-End>"] = "move_to_bottom",
                        ["<C-q>"] = open_with_trouble,
                        ["<M-q>"] = open_selected_with_trouble,
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
            extensions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = "smart_case",
                },
            },
        }),
        config = function(_, opts)
            local telescope = require("telescope")
            telescope.setup(opts)

            if make_cmd then
                telescope.load_extension("fzf")
            else
                vim.notify(
                    "No make command found, fzf-native cannot be compiled",
                    vim.log.levels.WARN
                )
            end
        end,
    },
}
