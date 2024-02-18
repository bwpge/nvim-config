return {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    config = function(_, opts)
        require("user.theme").run_setup("rose-pine", opts)
    end,
}
