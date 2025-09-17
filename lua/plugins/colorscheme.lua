local function spec(repo, name, opts)
    local t = {
        repo,
        lazy = false,
        priority = 1000,
        config = function(_, o)
            require(name).setup(o)
            vim.cmd("colorscheme " .. name)
        end,
    }

    return vim.tbl_deep_extend("force", t, opts or {})
end

return {
    spec("catppuccin/nvim", "catppuccin", {
        name = "catppuccin",
        opts = {
            flavour = "macchiato",
            styles = {
                miscs = {},
            },
            color_overrides = {
                macchiato = {
                    rosewater = "#fccfd4",
                    flamingo = "#fab8c0",
                    pink = "#d5b7fa",
                    mauve = "#b17af5",
                    red = "#f73e53",
                    maroon = "#f7a1ab",
                    peach = "#eaa071",
                    yellow = "#e5c07b",
                    green = "#5dcd9a",
                    teal = "#74baa8",
                    sky = "#6dbee3",
                    sapphire = "#7dc4e4",
                    blue = "#748bdf",
                    lavender = "#a9b9ef",
                    text = "#ccd5e5",
                    subtext1 = "#bcc5d4",
                    subtext0 = "#aab2bf",
                    -- TODO: fix these
                    overlay2 = "#6A7096",
                    overlay1 = "#6A7096",
                    overlay0 = "#6A7096",
                    surface2 = "#363848",
                    surface1 = "#363848",
                    surface0 = "#363848",
                    --
                    base = "#191D23",
                    mantle = "#13171b",
                    crust = "#0A0D0F",
                },
            },
            integrations = {
                telescope = {
                    enabled = true,
                    style = "nvchad",
                },
            },
            custom_highlights = function(colors)
                local utils = require("catppuccin.utils.colors")
                local accent = colors.blue

                return {
                    ["@constructor.lua"] = { link = "@punctuation.bracket" },
                    ["@function.builtin"] = { link = "Function" },
                    ["@function.macro"] = { fg = "#8aadf4", italic = true },
                    ["@lsp.mod.mutable.rust"] = { style = { "underline" } },
                    ["@lsp.type.builtinType"] = { link = "Keyword" },
                    ["@lsp.type.decorator"] = { link = "@punctuation.special" },
                    ["@lsp.type.enumMember"] = { link = "@keyword.operator" },
                    ["@lsp.type.lifetime.rust"] = { link = "@keyword" },
                    ["@lsp.type.macro.rust"] = { link = "Function" },
                    ["@lsp.type.namespace.cpp"] = { link = "Type" },
                    ["@lsp.type.selfKeyword"] = { link = "Keyword" },
                    ["@lsp.type.selfTypeKeyword"] = { link = "Keyword" },
                    ["@lsp.type.variable.rust"] = { link = "@variable" },
                    ["@lsp.typemod.variable.defaultLibrary"] = {},
                    ["@punctuation.special.rust"] = {},
                    ["@type.builtin.cpp"] = { link = "Keyword" },
                    ["BlinkCmpDocBorder"] = { link = "FloatBorder" },
                    ["BlinkCmpKindConstant"] = { link = "BlinkCmpKindKeyword" },
                    ["BlinkCmpKindEnum"] = { link = "BlinkCmpKindClass" },
                    ["BlinkCmpKindEnumMember"] = { link = "BlinkCmpKindClass" },
                    ["BlinkCmpKindField"] = { link = "BlinkCmpKindVariable" },
                    ["BlinkCmpKindFunction"] = { link = "Keyword" },
                    ["BlinkCmpKindInterface"] = { link = "BlinkCmpKindVariable" },
                    ["BlinkCmpKindKeyword"] = { link = "@variable" },
                    ["BlinkCmpKindMethod"] = { link = "BlinkCmpKindFunction" },
                    ["BlinkCmpKindModule"] = { link = "BlinkCmpKindKeyword" },
                    ["BlinkCmpKindProperty"] = { link = "BlinkCmpKindKeyword" },
                    ["BlinkCmpKindSnippet"] = { link = "BlinkCmpKindKeyword" },
                    ["BlinkCmpKindStruct"] = { link = "BlinkCmpKindKeyword" },
                    ["BlinkCmpKindText"] = { link = "BlinkCmpKindVariable" },
                    ["BlinkCmpKindUnit"] = { link = "BlinkCmpKindKeyword" },
                    ["BlinkCmpKindVariable"] = { link = "Function" },
                    ["BlinkCmpMenu"] = { link = "Pmenu" },
                    ["DiffChange"] = { bg = utils.darken(colors.yellow, 0.15, colors.base) },
                    ["DiffText"] = { bg = utils.darken(colors.peach, 0.3, colors.base) },
                    ["IlluminatedWordRead"] = { link = "LspReferenceRead" },
                    ["IlluminatedWordText"] = { link = "LspReferenceText" },
                    ["IlluminatedWordWrite"] = { link = "LspReferenceWrite" },
                    ["Pmenu"] = { fg = colors.overlay2, bg = colors.mantle },
                    ["SnacksInputBorder"] = { fg = accent, bg = colors.base },
                    ["SnacksInputTitle"] = { fg = colors.base, bg = accent },
                    ["TelescopePreviewTitle"] = { bg = accent, bold = true },
                    ["TelescopePromptPrefix"] = { fg = accent },
                    ["TelescopePromptTitle"] = { bg = accent, bold = true },
                    ["TelescopeResultsTitle"] = { bg = accent, bold = true },
                }
            end,
        },
    }),
}
