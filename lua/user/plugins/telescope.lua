local U = require("user.utils")
local nmap = U.nmap

local function get_make_cmd()
    if vim.fn.executable("make") == 1 then
        return "make"
    elseif vim.fn.executable("cmake") == 1 then
        return "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build"
    end
end
local make_cmd = get_make_cmd()

nmap("<leader>ff", "<cmd>Telescope find_files<cr>", "Go to file")
nmap("<leader>fg", "<cmd>Telescope live_grep<cr>", "Find in files (ripgrep)")
nmap("<leader>fs", "<cmd>Telescope grep_string<cr>", "Find word under cursor")
nmap("<leader>fb", "<cmd>Telescope buffers<cr>", "Go to buffer")
nmap("<leader>fo", "<cmd>Telescope lsp_document_symbols<cr>", "Go to buffer")
nmap("<leader>fO", "<cmd>Telescope lsp_workspace_symbols<cr>", "Go to buffer")
nmap("<leader>fd", "<cmd>Telescope diagnostics<cr>", "Go to diagnostics")
nmap("<leader>fk", "<cmd>Telescope keymaps<cr>", "Search keymaps")
nmap("<leader>fis", "<cmd>Telescope git_status<cr>", "Find dirty files")
nmap("<leader>fic", "<cmd>Telescope git_commits<cr>", "Find git commits")
nmap("<leader>fib", "<cmd>Telescope git_branches<cr>", "Find git branches")
nmap("<leader>f;", "<cmd>Telescope commands<cr>", "Search commands")
nmap("<leader>fhl", "<cmd>Telescope highlights<cr>", "Search highlight groups")
nmap("<leader>fcs", "<cmd>Telescope colorscheme<cr>", "Select colorscheme")
nmap("<F1>", "<cmd>Telescope help_tags<cr>", "Search help tags")

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
        version = "*",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = make_cmd },
        },
        cmd = "Telescope",
        keys = {},
        opts = U.merge_custom_opts("telescope", {
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
                        ["<C-End>"] = "move_to_bottom",
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
                U.notify_warn("No make command found, fzf-native cannot be compiled")
            end
        end,
    },
}
