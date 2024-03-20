return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        lazy = false,
        opts = {
            options = {
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
                disabled_filetypes = { "packer", "NVimTree", "neo-tree" },
            },
            sections = {
                lualine_b = {
                    { "branch", icon = "" },
                    "diff",
                    "diagnostics",
                },
                lualine_c = {
                    "filename",
                },
                lualine_x = { "filetype" },
                lualine_y = { "encoding", "fileformat", "progress" },
                lualine_z = { "location" },
            },
            extensions = { "lazy" },
        },
    },
}
