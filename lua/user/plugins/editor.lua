local utils = require("user.utils")
local lazy_kmap = utils.lazy_kmap

-- picks the convert method from text-case depending on whether the attached
-- lsp(s) support rename or not
local function textcase_convert(method)
    local textcase = require("textcase")
    local clients = vim.lsp.get_clients({ bufnr = 0 })

    for _, client in ipairs(clients) do
        local r = (client.server_capabilities or {}).renameProvider
        local has_rename = false

        if type(r) == "table" then
            has_rename = r.prepareProvider or false
        elseif type(r) == "boolean" then
            has_rename = r
        else
            has_rename = false
        end

        if has_rename then
            return textcase.lsp_rename(method)
        end
    end

    return textcase.current_word(method)
end

return {
    {
        "antoinemadec/FixCursorHold.nvim",
        event = "VeryLazy",
    },
    {
        "bwpge/homekey.nvim",
        event = "VeryLazy",
        opts = {
            exclude_filetypes = { "neo-tree" },
        },
    },
    {
        "kylechui/nvim-surround",
        event = "VeryLazy",
        version = "*",
        opts = {},
    },
    {
        "windwp/nvim-autopairs",
        event = "VeryLazy",
        opts = {},
    },
    {
        "danymat/neogen",
        opts = { snippet_engine = "luasnip" },
        cmd = { "Neogen" },
        keys = {
            lazy_kmap({ "n", "i" }, "<M-D>", "<cmd>Neogen<cr>", "Generate documentation (neogen)"),
        },
    },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
    },
    {
        "johmsalas/text-case.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        opts = {
            default_keymappings_enabled = false,
        },
        keys = {
            {
                "gas",
                function()
                    textcase_convert("to_snake_case")
                end,
                desc = "Convert text to snake case",
            },
            {
                "gak",
                function()
                    textcase_convert("to_dash_case")
                end,
                desc = "Convert text to kebab-case",
            },
            {
                "gau",
                function()
                    textcase_convert("to_constant_case")
                end,
                desc = "Convert text to screaming snake case",
            },
            {
                "gac",
                function()
                    textcase_convert("to_camel_case")
                end,
                desc = "Convert text to camel case",
            },
            {
                "gap",
                function()
                    textcase_convert("to_pascal_case")
                end,
                desc = "Convert text to pascal case",
            },
        },
        lazy = false,
    },
}
