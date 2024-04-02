local utils = require("user.utils")

local empty_ext = {
    sections = {},
    filetypes = { "nerdtree", "neo-tree" },
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
                    lualine_c = {
                        { "pretty_path", path_sep = "/" },
                    },
                    lualine_x = { "attached_lsp", "encoding" },
                    lualine_y = { "harpoon", "fileformat", "progress" },
                    lualine_z = { "location" },
                },
                extensions = { "lazy", empty_ext },
            })
        end,
    },
}
