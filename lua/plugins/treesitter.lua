local U = require("config.utils")

return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        build = ":TSUpdate",
        lazy = false,
        config = function(_, opts)
            local ts = require("nvim-treesitter")
            ts.setup(opts or {})

            if vim.fn.executable("tree-sitter") ~= 1 then
                U.warn("tree-sitter CLI is not installed")
                return
            end

            ts.install({
                "bash",
                "c",
                "cpp",
                "gitcommit",
                "gitignore",
                "go",
                "gomod",
                "gosum",
                "gowork",
                "html",
                "javascript",
                "json",
                "lua",
                "markdown",
                "markdown_inline",
                "rust",
                "toml",
                "typescript",
                "vim",
                "vimdoc",
                "yaml",
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        event = "LazyFile",
        init = function()
            -- Disable entire built-in ftplugin mappings to avoid conflicts.
            -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
            vim.g.no_plugin_maps = true
        end,
        opts = {
            lookahead = true,
            selection_modes = {
                ["@parameter"] = "v",
                ["@function.outer"] = "v",
                ["@class.outer"] = "v",
            },
            -- include_surrounding_whitespace = true,
        },
        config = function(_, opts)
            require("nvim-treesitter-textobjects").setup(opts)

            local select = require("nvim-treesitter-textobjects.select")
            vim.keymap.set({ "x", "o" }, "af", function()
                select.select_textobject("@function.outer", "textobjects")
            end)
            vim.keymap.set({ "x", "o" }, "if", function()
                select.select_textobject("@function.inner", "textobjects")
            end)
            vim.keymap.set({ "x", "o" }, "ac", function()
                select.select_textobject("@class.outer", "textobjects")
            end)
            vim.keymap.set({ "x", "o" }, "ic", function()
                select.select_textobject("@class.inner", "textobjects")
            end)
            vim.keymap.set({ "x", "o" }, "ia", function()
                select.select_textobject("@parameter.inner", "textobjects")
            end)
            vim.keymap.set({ "x", "o" }, "aa", function()
                select.select_textobject("@parameter.outer", "textobjects")
            end)
            vim.keymap.set({ "x", "o" }, "as", function()
                select.select_textobject("@local.scope", "locals")
            end)
            vim.keymap.set({ "x", "o" }, "ig", function()
                select.select_textobject("@generic.inner", "textobjects")
            end)
            vim.keymap.set({ "x", "o" }, "ag", function()
                select.select_textobject("@generic.outer", "textobjects")
            end)

            local swap = require("nvim-treesitter-textobjects.swap")
            vim.keymap.set("n", "<leader>>", function()
                swap.swap_next("@parameter.inner")
            end)
            vim.keymap.set("n", "<leader><", function()
                swap.swap_previous("@parameter.inner")
            end)
        end,
    },
}
