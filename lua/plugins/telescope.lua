local U = require("config.utils")
local nmap = U.nmap

local function get_make_cmd()
    if vim.fn.executable("make") == 1 then
        return "make"
    elseif vim.fn.executable("cmake") == 1 then
        return "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build"
    end
    return nil
end
local make_cmd = get_make_cmd()

U.set_config_keymap("telescope")

-- build a reasonable "ignored" find_files command
local find_command = {
    "rg",
    "--files",
    "--color",
    "never",
    "-uu",
}
for _, term in ipairs({
    ".git/",
    "node_modules",
    "/target/",
    "/build/",
    "/.cache/",
    "__pycache__",
}) do
    table.insert(find_command, "-g")
    table.insert(find_command, "!" .. term)
end

-- use a separate keymap for "ignored" find_files picker (this isn't needed
-- that frequently, but needed enough to warrant a keymap)
nmap("<leader>fF", function()
    require("telescope.builtin").find_files({
        find_command = find_command,
    })
end, "Go to file (includes ignored)")

return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = make_cmd },
        },
        cmd = "Telescope",
        keys = {},
        opts = function()
            local actions = require("telescope.actions")
            local transform_mod = require("telescope.actions.mt").transform_mod
            local custom_actions = {
                open_qflist = function()
                    local qf_cmd = ""
                    if vim.fn.exists(":Trouble") == 0 then
                        qf_cmd = "copen"
                    else
                        qf_cmd = "Trouble qflist"
                    end

                    vim.cmd("botright " .. qf_cmd)
                end,
            }
            custom_actions = transform_mod(custom_actions)

            return {
                defaults = {
                    selection_caret = " ",
                    prompt_prefix = "   ",
                    layout_strategy = "horizontal",
                    sorting_strategy = "ascending",
                    layout_config = {
                        horizontal = {
                            prompt_position = "top",
                        },
                        width = 0.87,
                        height = 0.75,
                    },
                    cycle_layout_list = { "horizontal", "vertical", "center" },
                    color_devicons = true,
                    mappings = {
                        i = {
                            ["<esc>"] = "close",
                            ["<C-s>"] = "select_horizontal",
                            ["<C-x>"] = false,
                            ["<C-j>"] = "move_selection_next",
                            ["<C-k>"] = "move_selection_previous",
                            ["<M-j>"] = "preview_scrolling_down",
                            ["<M-k>"] = "preview_scrolling_up",
                            ["<C-Down>"] = "preview_scrolling_down",
                            ["<C-Up>"] = "preview_scrolling_up",
                            ["<M-Down>"] = "cycle_history_next",
                            ["<M-Up>"] = "cycle_history_prev",
                            ["<C-Home>"] = "move_to_top",
                            ["<C-p>"] = require("telescope.actions.layout").toggle_preview,
                            ["<C-q>"] = actions.send_to_qflist + custom_actions.open_qflist,
                            ["<M-q>"] = actions.send_selected_to_qflist
                                + custom_actions.open_qflist,
                        },
                    },
                },
                pickers = {
                    find_files = {
                        layout_config = {
                            width = 0.55,
                            height = 0.45,
                        },
                        previewer = false,
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
            }
        end,
        config = function(_, opts)
            local telescope = require("telescope")
            telescope.setup(opts)

            if make_cmd then
                telescope.load_extension("fzf")
            else
                U.warn("No make command found, fzf-native cannot be compiled")
            end
        end,
    },
}
