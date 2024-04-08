local utils = require("user.utils")

local pretty_path = {
    "pretty_path",
    path_sep = "/",
}

local empty = {
    sections = {},
    filetypes = { "nerdtree", "neo-tree" },
}

local blame = {
    sections = { lualine_c = { pretty_path } },
    filetypes = { "fugitiveblame" },
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
            return utils.merge_custom_opts("lualine", {
                options = {
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                },
                sections = {
                    lualine_b = {
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
                extensions = { "lazy", empty, blame },
            })
        end,
    },
}
