return {
    "mhartington/formatter.nvim",
    event = "VeryLazy",
    dependencies = {
        {
            "mcauley-penney/tidy.nvim",
            opts = {
                enabled_on_save = false,
                filetype_exclude = { "diff" },
            },
        },
    },
    config = function()
        require("formatter").setup({
            filetype = {
                json = { require("formatter.filetypes.yaml").prettier },
                jsonc = { require("formatter.filetypes.yaml").prettier },
                lua = { require("formatter.filetypes.lua").stylua },
                yaml = { require("formatter.filetypes.yaml").prettier },
                ["*"] = { function() end },
            },
        })

        local formatter_group = vim.api.nvim_create_augroup("__formatter__", { clear = true })
        local autocmd = vim.api.nvim_create_autocmd

        -- format on save
        autocmd("BufWritePost", {
            group = formatter_group,
            command = ":FormatWrite",
        })

        -- using post event to avoid messing with buffer before formatting
        -- process has finished (which will cancel the formatter)
        autocmd("User", {
            pattern = "FormatterPost",
            group = formatter_group,
            callback = function()
                -- strip any whitespace not caught by formatters
                require("tidy").run()
            end,
        })
    end,
}