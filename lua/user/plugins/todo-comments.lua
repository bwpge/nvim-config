return {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
        sign_priority = 1,
        keywords = {
            DEBUG = { icon = " ", color = "debug" },
        },
        highlight = {
            keyword = "wide_bg",
            pattern = [[.*<(KEYWORDS)\s*(\(\w*\))?:]],
        },
        colors = {
            hint = { "Comment", "#10B981" },
            debug = { "Constant" },
            test = { "Keyword", "#FF00FF" },
            default = { "Comment", "#7C3AED" },
        },
        search = {
            pattern = [[\b(KEYWORDS)\s*(\(\w*\))?:]],
        },
    },
}
