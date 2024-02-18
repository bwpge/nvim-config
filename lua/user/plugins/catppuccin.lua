return {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function(_, opts)
        require("user.theme").run_setup("catppuccin", opts)
    end,
}
