local U = require("user.utils")

local pretty_path = {
    "pretty_path",
    path_sep = "/",
}

local empty = {
    sections = {},
    filetypes = { "nerdtree", "neo-tree" },
}

local minimal = {
    sections = { lualine_c = { pretty_path } },
    filetypes = {
        "query",
        "fugitiveblame",
        "dapui_scopes",
        "dapui_breakpoints",
        "dapui_stacks",
        "dapui_watches",
        "dap-repl",
        "dapui_console",
    },
}

return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            "bwpge/lualine-pretty-path",
        },
        lazy = false,
        opts = function()
            return U.merge_custom_opts("lualine", {
                options = {
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                },
                sections = {
                    lualine_b = {
                        "tabs",
                        { "branch", icon = "" },
                        "diagnostics",
                    },
                    lualine_c = { pretty_path },
                    lualine_x = { "attached_lsp", "encoding" },
                    lualine_y = { "harpoon", "fileformat", "progress" },
                    lualine_z = { "location" },
                },
                inactive_sections = {
                    lualine_c = { pretty_path },
                },
                extensions = { "lazy", empty, minimal },
            })
        end,
    },
}
