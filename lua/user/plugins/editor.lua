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
        opts = function()
            local surround = require("nvim-surround.config")
            return {
                surrounds = {
                    g = {
                        add = function()
                            local result = surround.get_input("Enter the type name: ")
                            if result then
                                return { { result .. "<" }, { ">" } }
                            end
                        end,
                        find = function()
                            if not vim.g.loaded_nvim_treesitter then
                                error("cannot find `generic_type` without treesitter")
                            end
                            local selection = surround.get_selection({ node = "generic_type" })
                            if selection then
                                return selection
                            end
                        end,
                        delete = "^(.-%<)().-(%>)()$",
                    },
                },
            }
        end,
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
            -- plugin might not be loaded if lazy=true
            vim.cmd("Lazy load markdown-preview.nvim")
            vim.fn["mkdp#util#install"]()
        end,
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        ft = { "markdown" },
        opts = {},
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
                local d = dir:sub(1, 4)
                vim.keymap.set("n", key, function()
                    require("illuminate")["goto_" .. d .. "_reference"](true)
                end, {
                    desc = "Go to " .. dir .. " hover reference",
                    buffer = buffer,
                })
            end

            map("]r", "next")
            map("[r", "previous")
        end,
        keys = {
            { "]r", desc = "Go to next hover reference" },
            { "[r", desc = "Go to previous hover reference" },
        },
    },
}
