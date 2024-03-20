return {
    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        build = ":TSUpdate",
        event = { "LazyFile", "VeryLazy" },
        config = function()
            local configs = require("nvim-treesitter.configs")

            ---@diagnostic disable-next-line: missing-fields
            configs.setup({
                ensure_installed = {
                    "c",
                    "cpp",
                    "lua",
                    "vim",
                    "vimdoc",
                    "javascript",
                    "typescript",
                    "html",
                    "rust",
                },
                sync_install = false,
                auto_install = true,
                highlight = {
                    enable = true,
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
                    move = {
                        enable = true,
                        set_jumps = true, -- whether to set jumps in the jumplist
                        goto_next_start = {
                            ["]m"] = "@function.outer",
                            ["]]"] = { query = "@class.outer", desc = "Next class start" },
                        },
                        goto_next_end = {
                            ["]M"] = "@function.outer",
                            ["]["] = "@class.outer",
                        },
                        goto_previous_start = {
                            ["[m"] = "@function.outer",
                            ["[["] = "@class.outer",
                        },
                        goto_previous_end = {
                            ["[M"] = "@function.outer",
                            ["[]"] = "@class.outer",
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
            })
        end,
    },
}
