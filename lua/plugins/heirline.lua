return {
    "rebelot/heirline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    config = function()
        local u = require("config.heirline")

        require("heirline").setup({
            opts = {
                colors = u.colors(),
            },
            statusline = u.statuslines,
            tabline = u.tablines,
        })
    end,
}
