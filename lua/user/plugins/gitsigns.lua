return {
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            -- use yellow for change color
            local yellow = require("user.theme").yellow()
            vim.cmd([[hi GitSignsChange guifg=]] .. yellow)
            require("gitsigns").setup()
        end,
    },
}
