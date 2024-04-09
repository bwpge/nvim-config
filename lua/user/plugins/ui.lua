local utils = require("user.utils")

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
        config = function()
            -- use a larger git icon and set all colors to a less harsh orange
            local devicons = require("nvim-web-devicons")
            local all = vim.tbl_filter(function(x)
                return x.icon == ""
            end, devicons.get_icons())

            ---@diagnostic disable-next-line: unused-local
            for k, v in pairs(all) do
                v.icon = "󰊢"
                v.color = "#dd5e32"
                v.cterm_color = 196
                devicons.set_icon({ k = v })
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
                    winhl = utils.make_winhl({
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
        opts = {
            height = 15,
            use_diagnostic_signs = true,
        },
    },
}
