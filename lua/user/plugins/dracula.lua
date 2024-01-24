return {
    {
        "Mofiqul/dracula.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            italic_comment = true,
            overrides = function(colors)
                return {
                    Function = { fg = colors.green },
                    Keyword = { fg = colors.pink },
                    Keywords = { fg = colors.pink },
                    ps1Function = { fg = colors.green },
                    ps1Cmdlet = { fg = colors.green },
                    ps1Variable = { link = "@variable" },
                    ps1Boolean = { link = "@number" },
                    ps1Operator = { link = "@operator" },
                    ["@field"] = { fg = colors.fg },
                    ["@field.yaml"] = { fg = colors.cyan },
                    ["@function.macro"] = { fg = colors.green, italic = true },
                    ["@keyword"] = { fg = colors.pink },
                    ["@keyword.function"] = { fg = colors.pink },
                    ["@label.markdown"] = { fg = colors.green },
                    ["@lsp.type.parameter"] = { fg = colors.orange, italic = true },
                    ["@lsp.type.property"] = { fg = colors.fg },
                    ["@markup.bold.markdown_inline"] = { fg = colors.orange, bold = true },
                    ["@markup.heading"] = { fg = colors.purple, bold = true },
                    ["@markup.italic.markdown_inline"] = { fg = colors.orange, italic = true },
                    ["@markup.link"] = { fg = colors.fg },
                    ["@markup.link.label.markdown_inline"] = { fg = colors.pink },
                    ["@markup.link.url"] = { fg = colors.cyan, underline = true },
                    ["@markup.raw.block"] = { fg = colors.fg },
                    ["@markup.raw.delimiter.markdown"] = { fg = colors.green },
                    ["@markup.raw.delimiter.markdown_inline"] = { fg = colors.green },
                    ["@markup.raw.markdown_inline"] = { fg = colors.green },
                    ["@parameter"] = { fg = colors.orange, italic = true },
                    ["@punctuation.delimiter.json"] = { fg = colors.pink },
                    ["@punctuation.delimiter.yaml"] = { fg = colors.pink },
                    ["@punctuation.special.markdown"] = { fg = colors.pink },
                    -- fix lua brace color
                    ["@constructor.lua"] = { fg = colors.fg },
                }
            end,
        },
        config = function(_, opts)
            if require("user.theme").name == "dracula" then
                require("dracula").setup(opts)
                vim.cmd([[colorscheme dracula]])
            end
        end,
    },
}
