return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            options = {
                theme = require("user.theme").name,
                -- icons_enabled = false,
            },
        },
    },
}
