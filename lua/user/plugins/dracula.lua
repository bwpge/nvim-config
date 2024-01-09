return {
    {
        "Mofiqul/dracula.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            italic_comment = true,
            overrides = function(colors)
                return {
                    Keyword = { fg = colors.pink },
                    Keywords = { fg = colors.pink },
                    ["@field"] = { fg = colors.fg },
                    ["@lsp.type.property"] = { fg = colors.fg },
                    ["@function.macro"] = { fg = colors.green, italic = true },
                    ["@keyword"] = { fg = colors.pink },
                    ["@keyword.function"] = { fg = colors.pink },
                    ["@parameter"] = { fg = colors.orange, italic = true },
                    ["@lsp.type.parameter"] = { fg = colors.orange, italic = true },
                    -- fix lua brace color
                    ["@constructor.lua"] = { fg = colors.fg },
                }
            end,
        },
        config = function(_, opts)
            if require("user.theme").name == 'dracula' then
                require("dracula").setup(opts)
                vim.cmd([[colorscheme dracula]])
            end
        end,
    },
}
