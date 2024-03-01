local kmap = require("user.utils").kmap

return {
    {
        "numToStr/Comment.nvim",
        event = "VeryLazy",
        config = function()
            require("Comment").setup()
        end,
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
        version = "*",
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup()
        end,
    },
    {
        "windwp/nvim-autopairs",
        event = "VeryLazy",
        config = function()
            require("nvim-autopairs").setup()
        end,
    },
    {
        "ggandor/leap.nvim",
        event = "VeryLazy",
        config = function()
            -- basically the same as create_default_mappings,
            -- just without `S` in `x` mode (nvim-surround)
            local keys = {
                { { "n", "x", "o" }, "s", "<Plug>(leap-forward)", "Leap forward" },
                { { "n", "o" }, "S", "<Plug>(leap-backward)", "Leap backward" },
                { { "n", "x", "o" }, "gs", "<Plug>(leap-from-window)", "Leap from window" },
            }
            for _, k in ipairs(keys) do
                kmap(k[1], k[2], k[3], k[4])
            end
            require("leap").opts.special_keys.prev_target = "<bs>"
            require("leap").opts.special_keys.prev_group = "<bs>"
            require("leap.user").set_repeat_keys("<cr>", "<bs>")
        end,
    },
    { "antoinemadec/FixCursorHold.nvim" },
}
