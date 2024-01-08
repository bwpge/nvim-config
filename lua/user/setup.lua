local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {
        "Mofiqul/dracula.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            -- make function tokens look as in vscode version
            overrides = function(colors)
                return {
                    Keyword = { fg = colors.pink },
                    Keywords = { fg = colors.pink },
                    ["@field"] = { fg = colors.fg },
                    ["@function.macro"] = { fg = colors.green, italic = true },
                    ["@keyword"] = { fg = colors.pink },
                    ["@keyword.function"] = { fg = colors.pink },
                    ["@parameter"] = { fg = colors.orange, italic = true },
                    -- fix lua brace color
                    ["@constructor.lua"] = { fg = colors.fg },
                }
            end,
        },
        config = function(_, opts)
            require("dracula").setup(opts)
            vim.cmd([[colorscheme dracula]])
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {
            options = {
                theme = 'dracula',
                icons_enabled = false,
            },
        },
    },
    {
        "numToStr/Comment.nvim",
        config = function() require("Comment").setup() end,
    },
    {
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup({}) end,
    },
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            -- use yellow for change color
            local theme = require("dracula").colors()
            vim.cmd([[hi GitSignsChange guifg=]] .. theme.yellow)
            require("gitsigns").setup()
        end,
    },
    {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        config = function() require("nvim-surround").setup({}) end,
    },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.5",
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function ()
            local configs = require("nvim-treesitter.configs")

            configs.setup({
                ensure_installed = {
                    "c", "cpp", "lua", "vim", "vimdoc", "javascript", "typescript", "html", "rust",
                },
                sync_install = false,
                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                indent = { enable = true },
            })
        end
    },
})
