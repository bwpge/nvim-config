local U = require("user.utils")

return {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = "LazyFile",
    keys = {
        { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Open todo list" },
    },
    opts = U.merge_custom_opts("todo-comments", {
        sign_priority = 1,
        keywords = {
            DEBUG = { icon = " ", color = "debug" },
        },
        highlight = {
            keyword = "wide_bg",
            pattern = [[.*<((KEYWORDS)%(\(.{-1,}\))?):]],
        },
        colors = {
            hint = { "Comment", "#10B981" },
            debug = { "Constant" },
            test = { "Keyword", "#FF00FF" },
            default = { "Comment", "#7C3AED" },
        },
        search = {
            pattern = [[\b(KEYWORDS)(\(\w*\))*:]],
        },
    }),
}
