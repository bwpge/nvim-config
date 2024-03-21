local theme = require("user.theme")

local function spec(repo, name, opts)
    local t = {
        repo,
        lazy = false,
        priority = 1000,
        config = theme.make_config(name),
    }

    return vim.tbl_deep_extend("force", t, opts or {})
end

return {
    spec("Mofiqul/dracula.nvim", "dracula", {
        opts = {
            italic_comment = true,
            overrides = function(colors)
                return {
                    ["@character"] = { link = "@string" },
                    ["@constructor.lua"] = { fg = colors.fg },
                    ["@field"] = { fg = colors.fg },
                    ["@field.yaml"] = { fg = colors.cyan },
                    ["@function.macro"] = { fg = colors.green, italic = true },
                    ["@keyword"] = { link = "Keyword" },
                    ["@keyword.function"] = { link = "Keyword" },
                    ["@label.markdown"] = { fg = colors.green },
                    ["@lsp.mod.constant.rust"] = { link = "@constant" },
                    ["@lsp.mod.mutable.rust"] = { underline = true },
                    ["@lsp.mod.static.rust"] = { link = "@constant" },
                    ["@lsp.type.builtinAttribute.rust"] = { fg = colors.fg },
                    ["@lsp.type.character.rust"] = { link = "@string" },
                    ["@lsp.type.decorator.rust"] = { fg = colors.fg },
                    ["@lsp.type.deriveHelper.rust"] = { fg = colors.fg },
                    ["@lsp.type.enumMember"] = { fg = colors.orange },
                    ["@lsp.type.interface"] = { fg = colors.cyan, italic = true },
                    ["@lsp.type.keyword"] = { link = "Keyword" },
                    ["@lsp.type.macro"] = { link = "@function.macro" },
                    ["@lsp.type.namespace"] = { fg = colors.cyan },
                    ["@lsp.type.parameter"] = { fg = colors.orange, italic = true },
                    ["@lsp.type.property"] = { fg = colors.fg },
                    ["@lsp.type.selfKeyword.rust"] = { link = "Keyword" },
                    ["@lsp.type.selfTypeKeyword.rust"] = { link = "Keyword" },
                    ["@lsp.type.typeAlias"] = { link = "@type" },
                    ["@lsp.type.typeParameter"] = { link = "@type" },
                    ["@lsp.typemod.method.static.rust"] = { link = "@function" },
                    ["@markup.bold.markdown_inline"] = { fg = colors.orange, bold = true },
                    ["@markup.heading"] = { fg = colors.purple, bold = true },
                    ["@markup.italic.markdown_inline"] = { fg = colors.orange, italic = true },
                    ["@markup.link"] = { fg = colors.fg },
                    ["@markup.link.label.markdown_inline"] = { fg = colors.pink },
                    ["@markup.link.url"] = { fg = colors.cyan, underline = true },
                    ["@markup.link.vimdoc"] = { fg = colors.orange, bold = true },
                    ["@markup.raw.block"] = { fg = colors.fg },
                    ["@markup.raw.delimiter.markdown"] = { fg = colors.green },
                    ["@markup.raw.delimiter.markdown_inline"] = { fg = colors.green },
                    ["@markup.raw.markdown_inline"] = { fg = colors.green },
                    ["@module"] = { fg = colors.cyan },
                    ["@numer.float"] = { link = "@number" },
                    ["@parameter"] = { fg = colors.orange, italic = true },
                    ["@punctuation.delimiter.json"] = { link = "Keyword" },
                    ["@punctuation.delimiter.yaml"] = { link = "Keyword" },
                    ["@punctuation.special.markdown"] = { link = "Keyword" },
                    ["@punctuation.special.python"] = { link = "Keyword" },
                    ["@punctuation.special.rust"] = { link = "Keyword" },
                    ["@string.escape"] = { link = "Keyword" },
                    ["@string.regexp"] = { link = "@string" },
                    ["@type"] = { fg = colors.cyan },
                    ["@type.builtin"] = { link = "@type" },
                    ["@variable.member"] = { fg = colors.fg },
                    ["@variable.parameter"] = { link = "@parameter" },
                    Character = { link = "String" },
                    Constant = { fg = colors.purple },
                    CursorLine = { bg = "#353747" },
                    DiagnosticUnnecessary = { fg = colors.comment },
                    DiffChange = { fg = colors.yellow },
                    diffIndexLine = { fg = colors.fg },
                    diffSubname = { fg = colors.fg },
                    Function = { fg = colors.green },
                    GitSignsAddPreview = { fg = colors.bright_green },
                    GitSignsChange = { fg = colors.yellow },
                    GitSignsChangeLn = { fg = colors.black, bg = colors.yellow },
                    GitSignsDeletePreview = { fg = colors.red },
                    Keyword = { fg = colors.pink },
                    Keywords = { link = "Keyword" },
                    LazyNormal = { link = "NeoTreeNormal" },
                    LspInlayHint = { fg = "#a2a7c4" },
                    LspReferenceRead = { bg = "#506473" },
                    LspReferenceText = { bg = "#506473" },
                    LspReferenceWrite = { bg = "#506473" },
                    NeoTreeGitModified = { fg = colors.yellow },
                    NeoTreeGitUnstaged = { fg = colors.yellow },
                    ps1Boolean = { link = "@number" },
                    ps1Cmdlet = { link = "@function" },
                    ps1Function = { link = "@function" },
                    ps1Operator = { link = "@operator" },
                    ps1Variable = { link = "@variable" },
                    TelescopeResultsDiffChange = { fg = colors.yellow },
                    ToggleTermBorder = { fg = colors.comment },
                    zshDeref = { link = "@variable" },
                    zshFunction = { link = "@function" },
                    zshOperator = { link = "@operator" },
                    zshShortDeref = { link = "zshDeref" },
                    zshSubstDelim = { link = "@variable" },
                    zshSubstQuoted = { link = "@variable" },
                    zshTypes = { link = "@keyword" },
                }
            end,
        },
    }),
    spec("catppuccin/nvim", "catppuccin", {
        name = "catppuccin",
        opts = {
            flavour = "macchiato",
            highlight_overrides = {
                all = {
                    ["@constructor.lua"] = { link = "@punctuation.bracket" },
                    ["@function.builtin"] = { link = "Function" },
                },
            },
        },
    }),
    spec("ellisonleao/gruvbox.nvim", "gruvbox"),
    spec("rebelot/kanagawa.nvim", "kanagawa"),
    spec("navarasu/onedark.nvim", "onedark"),
    spec("rose-pine/neovim", "rose-pine", { name = "rose-pine" }),
    spec("folke/tokyonight.nvim", "tokyonight", { opts = { style = "moon" } }),
}
