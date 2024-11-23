local U = require("user.utils")
local nmap = U.lazy_nmap

-- color style based on NvChad telescope style, see:
-- https://nvchad.com/docs/features/#telescope_nvim
local function make_hl_map()
    local F = require("colorful.color.functional")
    local Highlight = require("colorful.highlight")

    local hl = Highlight("Normal")
    local fg = hl.fg
    local bg = hl:map_copy("bg", F.lighten(0.02))
    local bg_dark = hl:map_copy("bg", F.lighten(-0.045))
    local dim = hl:map_copy("bg", F.lighten(0.125))
    local accent = Highlight.get_fg("@function", "Function")

    return {
        ["*"] = {
            TelescopeNormal = { fg = fg, bg = bg_dark },
            TelescopePreviewBorder = { fg = bg_dark, bg = bg_dark },
            TelescopePreviewTitle = { fg = accent, reverse = true, bold = true },
            TelescopePromptBorder = { fg = bg, bg = bg },
            TelescopePromptCounter = { fg = dim },
            TelescopePromptNormal = { fg = fg, bg = bg },
            TelescopePromptPrefix = { fg = accent },
            TelescopePromptTitle = { fg = accent, reverse = true, bold = true },
            TelescopeResultsBorder = { fg = bg_dark, bg = bg_dark },
            TelescopeResultsTitle = { fg = bg_dark, bg = bg_dark },
        },
        ["catppuccin*"] = {
            FloatTitle = { link = "Title" },
        },
    }
end

return {
    {
        "bwpge/colorful.nvim",
        event = "VeryLazy",
        opts = { highlights = make_hl_map },
    },
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
        "stevearc/dressing.nvim",
        -- manually lazy load
        init = function()
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.select = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.select(...)
            end
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.input = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.input(...)
            end
        end,
        opts = {
            input = {
                title_pos = "center",
                prefer_width = 30,
                min_width = 25,
                border = {
                    "▕",
                    { " ", "TelescopePromptTitle" },
                    "▏",
                    "▏",
                    " ",
                    "▔",
                    " ",
                    "▕",
                },
                win_options = {
                    winhl = U.make_winhl({
                        Normal = "TelescopeNormal",
                        FloatBorder = "TelescopePromptPrefix",
                        FloatTitle = "TelescopePromptTitle",
                    }),
                },
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
            nmap("<leader>xx", "<cmd>Trouble diagnostics<cr>", "Open trouble diagnostics"),
            nmap("<leader>xq", "<cmd>Trouble quickfix<cr>", "Open trouble quickfix list"),
        },
        opts = {
            height = 15,
            use_diagnostic_signs = true,
        },
    },
}
