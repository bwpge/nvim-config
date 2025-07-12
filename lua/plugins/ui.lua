local U = require("config.utils")

return {
    {
        "nvim-tree/nvim-web-devicons",
        opts = {
            override_by_filename = {
                ["go.mod"] = {
                    icon = "",
                    color = "#519aba",
                    cterm_color = "74",
                    name = "GoMod",
                },
                ["go.sum"] = {
                    icon = "",
                    color = "#519aba",
                    cterm_color = "74",
                    name = "GoSum",
                },
            },
        },
        config = function(_, opts)
            local devicons = require("nvim-web-devicons")
            devicons.setup(opts)

            -- use a larger git icon and set all colors to a less harsh orange
            local all = vim.tbl_filter(function(x)
                return x.icon == ""
            end, devicons.get_icons())

            for k, v in pairs(all) do
                v.icon = "󰊢"
                v.color = "#dd5e32"
                v.cterm_color = 196
                devicons.set_icon({ [k] = v })
            end
        end,
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        cmd = { "TodoTrouble", "TodoTelescope" },
        event = "LazyFile",
        keys = {
            { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Open todo list" },
        },
        opts = {
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
        },
    },
    {
        "folke/snacks.nvim",
        priority = 999,
        lazy = false,
        opts = {
            input = {
                icon = "",
                win = {
                    style = {
                        backdrop = false,
                        position = "float",
                        border = {
                            "▕",
                            { " ", "SnacksInputTitle" },
                            "▏",
                            "▏",
                            " ",
                            "▔",
                            " ",
                            "▕",
                        },
                        title_pos = "left",
                        height = 1,
                        width = 35,
                        relative = "cursor",
                        noautocmd = true,
                        row = -3,
                        wo = {
                            cursorline = false,
                        },
                        bo = {
                            filetype = "snacks_input",
                            buftype = "prompt",
                        },
                        b = {
                            completion = false, -- disable blink completions in input
                        },
                        keys = {
                            n_esc = { "<esc>", { "cmp_close", "cancel" }, mode = "n", expr = true },
                            i_esc = {
                                "<esc>",
                                { "cmp_close", "cancel" },
                                mode = "i",
                                expr = true,
                            },
                            i_cr = {
                                "<cr>",
                                { "cmp_accept", "confirm" },
                                mode = { "i", "n" },
                                expr = true,
                            },
                            i_tab = {
                                "<tab>",
                                { "cmp_select_next", "cmp" },
                                mode = "i",
                                expr = true,
                            },
                            i_ctrl_w = { "<c-w>", "<c-s-w>", mode = "i", expr = true },
                            i_up = { "<up>", { "hist_up" }, mode = { "i", "n" } },
                            i_down = { "<down>", { "hist_down" }, mode = { "i", "n" } },
                            q = "cancel",
                        },
                    },
                },
                expand = true,
            },
        },
    },
    {
        "j-hui/fidget.nvim",
        event = "LazyFile",
        opts = {
            progress = {
                display = {
                    done_icon = "",
                    done_style = "DiagnosticOk",
                },
            },
        },
    },
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cmd = { "Trouble", "TroubleToggle" },
        keys = {
            U.lazy_nmap("<leader>xx", "<cmd>Trouble diagnostics<cr>", "Open trouble diagnostics"),
            U.lazy_nmap("<leader>xq", "<cmd>Trouble quickfix<cr>", "Open trouble quickfix list"),
            U.lazy_nmap(
                "<leader>xt",
                "<cmd>Lazy! load todo-comments.nvim | Trouble todo<cr>",
                "Open trouble todo list"
            ),
        },
        opts = {
            auto_preview = false,
            focus = true,
            use_diagnostic_signs = true,
        },
    },
}
