local U = require("config.utils")
local S = require("config.state")

return {
    {
        "stevearc/conform.nvim",
        event = "VeryLazy",
        opts = {
            formatters_by_ft = {
                go = { "gofumpt", "golines" },
                lua = { "stylua" },
                python = { "black", "isort" },
                ["_"] = { "trim_all" },
            },
        },
        config = function(_, opts)
            require("conform").setup(opts)
            U.set_config_keymap("format")

            if S.get("format_on_save") == nil then
                S.set("format_on_save", true)
            end

            -- copied mostly from conform setup, adapted for a global toggle:
            -- https://github.com/stevearc/conform.nvim/blob/016bc8174a675e1dbf884b06a165cd0c6c03f9af/lua/conform/init.lua#L89-L122
            local aug = vim.api.nvim_create_augroup("FormatOnSave", { clear = true })
            vim.api.nvim_create_autocmd("BufWritePre", {
                desc = "Format on save",
                pattern = "*",
                group = aug,
                callback = function(args)
                    if
                        S.get("format_on_save") ~= true
                        or not vim.api.nvim_buf_is_valid(args.buf)
                        or vim.bo[args.buf].buftype ~= ""
                    then
                        return
                    end

                    require("conform").format({
                        buf = args.buf,
                        async = false,
                        timeout_ms = 5000,
                        lsp_format = "fallback",
                    })
                end,
            })
        end,
    },
}
