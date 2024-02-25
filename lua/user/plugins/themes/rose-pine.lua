return {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    config = require("user.theme").make_config("rose-pine"),
}
