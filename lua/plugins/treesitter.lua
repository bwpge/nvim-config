return {
    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        build = ":TSUpdate",
        event = { "LazyFile", "VeryLazy" },
        opts = {
            ensure_installed = {
                "bash",
                "c",
                "cpp",
                "gitcommit",
                "gitignore",
                "go",
                "html",
                "javascript",
                "json",
                "jsonc",
                "lua",
                "markdown",
                "markdown_inline",
                "rust",
                "toml",
                "typescript",
                "vim",
                "vimdoc",
                "yaml",
            },
            sync_install = false,
            auto_install = true,
            highlight = {
                enable = true,
                disable = function(_, buf)
                    return not vim.b[buf].is_large_buf
                end,
                additional_vim_regex_highlighting = false,
            },
            indent = { enable = true },

            -- nvim-treesitter-textobjects
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner",
                        ["ia"] = "@parameter.inner",
                        ["aa"] = "@parameter.outer",
                        ["as"] = {
                            query = "@scope",
                            query_group = "locals",
                        },
                        ["ag"] = "@generic.outer",
                        ["ig"] = "@generic.inner",
                    },
                    selection_modes = {
                        ["@parameter"] = "v",
                        ["@function.outer"] = "v",
                        ["@class.outer"] = "v",
                    },
                    include_surrounding_whitespace = true,
                },
                swap = {
                    enable = true,
                    swap_next = {
                        ["<leader>>"] = "@parameter.inner",
                    },
                    swap_previous = {
                        ["<leader><"] = "@parameter.inner",
                    },
                },
                lsp_interop = {
                    enable = true,
                    border = "single",
                    floating_preview_opts = {},
                    peek_definition_code = {
                        ["<leader>gf"] = "@function.outer",
                        ["<leader>gF"] = "@class.outer",
                    },
                },
            },
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
    },
}
