return {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    config = function(_, opts)
        require("user.theme").run_setup("gruvbox", opts)
    end,
}
