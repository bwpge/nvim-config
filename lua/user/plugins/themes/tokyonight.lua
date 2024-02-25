return {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = require("user.theme").make_config("tokyonight"),
}
