return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            {
                "WhoIsSethDaniel/lualine-lsp-progress.nvim",
                config = true,
            },
        },
        opts = {
            sections = {
                lualine_b = {
                    { "branch", icon = "" },
                    "diff",
                    "diagnostics",
                },
                lualine_c = {
                    "filename",
                    {
                        "lsp_progress",
                        icon = "",
                        separators = {
                            component = " ",
                            progress = " | ",
                            message = { pre = "", post = "" },
                            percentage = { pre = "", post = "%% " },
                            title = { pre = "", post = ": " },
                            lsp_client_name = { pre = "", post = "" },
                            spinner = { pre = "", post = "" },
                        },
                        display_components = {
                            { "title", "message" },
                        },
                    },
                },
                lualine_x = { "filetype" },
                lualine_y = { "encoding", "fileformat", "progress" },
                lualine_z = { "location" },
            },
            options = {
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
                disabled_filetypes = { "packer", "NVimTree", "neo-tree" },
            },
        },
    },
}
