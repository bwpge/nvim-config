-- color style based on NvChad telescope style, see:
-- https://nvchad.com/docs/features/#telescope_nvim
local function make_hl_map()
    local F = require("colorful.functional")
    local Highlight = require("colorful.highlight")

    local hl = Highlight("Normal")
    local fg = hl.fg
    local bg = hl:map_bg(F.lighten(0.02))
    local bg_dark = hl:map_bg(F.lighten(-0.045))
    local dim = hl:map_bg(F.lighten(0.125))
    local accent = Highlight.get_fg("@function", "Function")

    return {
        ["*"] = {
            TelescopeNormal = { fg = fg, bg = bg_dark },
            TelescopePreviewBorder = { fg = bg_dark, bg = bg_dark },
            TelescopePreviewTitle = { fg = accent, bg = bg_dark, reverse = true, bold = true },
            TelescopePromptBorder = { fg = bg, bg = bg },
            TelescopePromptCounter = { fg = dim },
            TelescopePromptNormal = { fg = fg, bg = bg },
            TelescopePromptPrefix = { fg = accent },
            TelescopePromptTitle = { fg = accent, bg = bg, reverse = true, bold = true },
            TelescopeResultsBorder = { fg = bg_dark, bg = bg_dark },
            TelescopeResultsTitle = { fg = bg_dark, bg = bg_dark },
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
                win_options = {
                    winhl = "Normal:TelescopeNormal,FloatBorder:TelescopePreviewBorder,Title:TelescopePreviewTitle",
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
