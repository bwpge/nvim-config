return {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
        highlight = {
            keyword = "bg",
            pattern = [[.*<(KEYWORDS)\s*(\(\w*\))?:]],
        },
        search = {
            pattern = [[\b(KEYWORDS)\s*(\(\w*\))?:]],
        },
    },
}
