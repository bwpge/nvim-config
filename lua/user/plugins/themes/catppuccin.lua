return {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = require("user.theme").make_config("catppuccin"),
}
