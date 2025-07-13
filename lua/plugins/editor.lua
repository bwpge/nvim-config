local U = require("config.utils")

local function grapple_toggle()
    local action = "Added"
    if require("grapple").exists() then
        action = "Removed"
    end

    ---@diagnostic disable-next-line: param-type-mismatch
    local ok, err = pcall(vim.cmd, "Grapple toggle")
    if ok then
        vim.notify(action .. " grapple tag: " .. vim.fn.expand("%:."))
        vim.schedule(vim.cmd.redrawstatus)
    else
        vim.notify("Failed to toggle grapple tag: " .. err, vim.log.levels.WARN)
    end
end

return {
    {
        "bwpge/homekey.nvim",
        event = "VeryLazy",
        opts = {},
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
        "echasnovski/mini.pairs",
        version = "*",
        event = "VeryLazy",
        opts = {},
    },
    {
        "MagicDuck/grug-far.nvim",
        keys = {
            {
                "<leader>rr",
                "<cmd>GrugFar<cr>",
                desc = "Open find and replace",
            },
            {
                "<leader>rr",
                function()
                    local lines = vim.fn.getregion(
                        vim.fn.getpos("."),
                        vim.fn.getpos("v"),
                        { type = vim.fn.mode() }
                    )
                    local text = table.concat(vim.iter(lines):map(vim.trim):totable())
                    require("grug-far").open({ prefills = { search = text } })
                end,
                desc = "Open find and replace with current selection",
                mode = "x",
            },
        },
        cmd = "GrugFar",
        opts = {
            keymaps = {
                nextInput = { n = "<tab>", i = "<C-n>" },
                prevInput = { n = "<S-Tab>", i = "<C-p>" },
                close = { n = "q", i = "<C-c>" },
            },
        },
    },
    {
        "cbochs/grapple.nvim",
        dependencies = {
            { "nvim-tree/nvim-web-devicons" },
        },
        cmd = "Grapple",
        keys = {
            { "<localleader>", "<cmd>Grapple toggle_tags<cr>", desc = "Grapple: Toggle tags menu" },
            { "<leader><localleader>", grapple_toggle, desc = "Grapple: Toggle tag" },
            { "[g", "<cmd>Grapple cycle_tags prev<cr>", desc = "Grapple: Go to next tag" },
            { "]g", "<cmd>Grapple cycle_tags next<cr>", desc = "Grapple: Go to previous tag" },
        },
        opts = {
            scope = "git_branch",
            icons = true,
            quick_select = "123456789",
        },
        config = function(_, opts)
            require("grapple").setup(opts)
            require("telescope").load_extension("grapple")
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
            filetypes_denylist = {
                "neo-tree",
                "fugitive",
            },
        },
        config = function(_, opts)
            require("illuminate").configure(opts)
            U.set_config_keymap("illuminate")
        end,
    },
}
