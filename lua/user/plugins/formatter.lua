-- prettier adds trailing commas by default without config
local function prettier_no_trailing_comma()
    return {
        exe = "prettier",
        args = {
            "--stdin-filepath",
            vim.fn.shellescape(vim.api.nvim_buf_get_name(0), true),
        },
        stdin = true,
        try_node_modules = true,
    }
end

return {
    "mhartington/formatter.nvim",
    event = "LazyFile",
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
                python = {
                    require("formatter.filetypes.python").black,
                    require("formatter.filetypes.python").isort,
                },
                json = prettier_no_trailing_comma,
                jsonc = prettier_no_trailing_comma,
                lua = { require("formatter.filetypes.lua").stylua },
                toml = { require("formatter.filetypes.toml").taplo },
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
