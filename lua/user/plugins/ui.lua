-- color style based on NvChad telescope style, see:
-- https://github.com/NvChad/NvChad/blob/bccd8e4ab9942c57eaeee76c7e41c2b41cba17c4/lua/colors/highlights.lua#L119C1-L131C33
local function make_hl_map()
    local F = require("colorful.functional")
    local Highlight = require("colorful.highlight")

    local hl = Highlight("Normal")
    local fg = hl.fg
    local bg = hl:map_bg(F.lighten(0.02))
    local bg_dark = hl:map_bg(F.lighten(-0.045))
    local dim = hl:map_bg(F.lighten(0.2))
    local accent = Highlight.get_fg("@function", "Function")

    return {
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
    }
end

return {
    {
        "bwpge/colorful.nvim",
        opts = { highlights = make_hl_map },
        event = "VeryLazy",
    },
    {
        "stevearc/dressing.nvim",
        event = "VeryLazy",
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
        event = "VeryLazy",
        opts = {
            height = 15,
            use_diagnostic_signs = true,
        },
    },
}
