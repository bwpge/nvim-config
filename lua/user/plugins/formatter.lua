-- formatter.nvim might configure prettier to use json5 parser, which adds
-- trailing commas by default. prettier also won't format gitignored files by
-- default so we need to use `--ignore-path=`.
local function json_prettier()
    return {
        exe = "prettier",
        args = {
            "--ignore-path=",
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
                json = json_prettier,
                jsonc = json_prettier,
                lua = { require("formatter.filetypes.lua").stylua },
                toml = { require("formatter.filetypes.toml").taplo },
                yaml = { require("formatter.filetypes.yaml").prettier },
                -- allow tidy to clean up whitespace on FormatterPost instead of using sed
                ["*"] = { function() end },
            },
        })

        local formatter_group = vim.api.nvim_create_augroup("NvimFormatter", { clear = true })
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
