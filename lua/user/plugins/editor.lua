local U = require("user.utils")
local kmap = U.lazy_kmap

return {
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
            kmap({ "n", "i" }, "<M-D>", "<cmd>Neogen<cr>", "Neogen: Generate documentation"),
        },
    },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        keys = {
            { "<leader>md", "<cmd>MarkdownPreview<cr>", desc = "Open markdown live preview" },
        },
        ft = { "markdown" },
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
    },
    {
        "RRethy/vim-illuminate",
        event = "LazyFile",
        opts = {
            delay = 400,
            large_file_cutoff = 2000,
            large_file_overrides = {
                providers = { "lsp" },
            },
        },
        config = function(_, opts)
            require("illuminate").configure(opts)

            local function map(key, dir, buffer)
                vim.keymap.set("n", key, function()
                    require("illuminate")["goto_" .. dir .. "_reference"](true)
                end, {
                    desc = "Go to " .. dir .. " hover reference",
                    buffer = buffer,
                })
            end

            map("]]", "next")
            map("[[", "prev")

            -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
            vim.api.nvim_create_autocmd("FileType", {
                callback = function()
                    local buffer = vim.api.nvim_get_current_buf()
                    map("]]", "next", buffer)
                    map("[[", "prev", buffer)
                end,
            })
        end,
        keys = {
            { "]]", desc = "Go to next hover reference" },
            { "[[", desc = "Go to prev hover reference" },
        },
    },
}
