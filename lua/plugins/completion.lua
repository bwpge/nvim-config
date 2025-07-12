return {
    {
        "saghen/blink.cmp",
        version = "*",
        dependencies = {
            { "rafamadriz/friendly-snippets" },
        },
        event = { "InsertEnter", "CmdlineEnter" },
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            enabled = function()
                local disable_ft = {
                    "grug-far",
                    "gitcommit",
                }
                return not vim.tbl_contains(disable_ft, vim.bo.filetype)
            end,
            keymap = {
                preset = "super-tab",
                ["<M-k>"] = { "scroll_documentation_up", "fallback" },
                ["<M-j>"] = { "scroll_documentation_down", "fallback" },
                ["<M-i>"] = { "show_documentation", "hide_documentation" },
            },
            cmdline = {
                keymap = { preset = "inherit" },
                completion = { menu = { auto_show = true } },
            },
            appearance = {
                nerd_font_variant = "normal",
                kind_icons = {
                    Text = "",
                    Method = "",
                    Function = "",
                    Constructor = "",
                    Field = "",
                    Variable = "",
                    Class = "",
                    Interface = "",
                    Module = "󰅩",
                    Property = "",
                    Unit = "",
                    Value = "",
                    Enum = "",
                    Keyword = "",
                    Snippet = "󱄽",
                    Color = "",
                    File = "",
                    Reference = "",
                    Folder = "",
                    EnumMember = "",
                    Constant = "",
                    Struct = "",
                    Event = "",
                    Operator = "",
                    TypeParameter = "",
                },
            },
            completion = {
                trigger = { show_in_snippet = false },
                documentation = {
                    auto_show = true,
                    window = { border = "single" },
                },
                list = {
                    selection = {
                        preselect = function()
                            return not require("blink.cmp").snippet_active({ direction = 1 })
                        end,
                        auto_insert = false,
                    },
                },
            },
            sources = {
                default = { "lsp", "snippets", "buffer" },
            },
            fuzzy = { implementation = "prefer_rust_with_warning" },
        },
        opts_extend = { "sources.default" },
    },
}
