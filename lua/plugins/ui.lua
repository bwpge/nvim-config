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
