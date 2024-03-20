local utils = require("user.utils")
local lazy_kmap = utils.lazy_kmap

return {
    {
        "antoinemadec/FixCursorHold.nvim",
        event = "VeryLazy",
    },
    {
        "numToStr/Comment.nvim",
        event = "VeryLazy",
        opts = {},
    },
    {
        "bwpge/homekey.nvim",
        event = "VeryLazy",
        opts = {
            exclude_filetypes = { "neo-tree" },
        },
    },
    {
        "kylechui/nvim-surround",
        event = "VeryLazy",
        version = "*",
        opts = {},
    },
    {
        "windwp/nvim-autopairs",
        event = "VeryLazy",
        opts = {},
    },
    {
        "danymat/neogen",
        opts = { snippet_engine = "luasnip" },
        cmd = { "Neogen" },
        keys = {
            lazy_kmap({ "n", "i" }, "<M-D>", "<cmd>Neogen<cr>", "Generate documentation (neogen)"),
        },
    },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
    },
}
