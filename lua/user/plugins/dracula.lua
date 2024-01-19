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
                    ["@lsp.type.property"] = { fg = colors.fg },
                    ["@function.macro"] = { fg = colors.green, italic = true },
                    ["@keyword"] = { fg = colors.pink },
                    ["@keyword.function"] = { fg = colors.pink },
                    ["@parameter"] = { fg = colors.orange, italic = true },
                    ["@lsp.type.parameter"] = { fg = colors.orange, italic = true },
                    ["@punctuation.delimiter.yaml"] = { fg = colors.pink },
                    ["@punctuation.delimiter.json"] = { fg = colors.pink },
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
