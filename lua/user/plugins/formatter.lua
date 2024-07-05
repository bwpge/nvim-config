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
    cmd = "Format",
    keys = {
        { "<M-F>", "<cmd>Format<cr>", desc = "Format the current buffer" },
    },
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
                c = { require("formatter.filetypes.c").clangformat },
                cpp = { require("formatter.filetypes.cpp").clangformat },
                go = {
                    require("formatter.filetypes.go").gofumpt,
                    require("formatter.filetypes.go").golines,
                },
                python = {
                    require("formatter.filetypes.python").black,
                    require("formatter.filetypes.python").isort,
                },
                json = json_prettier,
                jsonc = json_prettier,
                lua = { require("formatter.filetypes.lua").stylua },
                rust = { require("formatter.filetypes.rust").rustfmt },
                toml = { require("formatter.filetypes.toml").taplo },
                yaml = { require("formatter.filetypes.yaml").prettier },
                -- trigger FormatterPost event with an empty function to use tidy.nvim
                ["*"] = { function() end },
            },
        })

        -- format on save
        vim.api.nvim_create_autocmd("BufWritePost", {
            command = "FormatWrite",
        })

        -- using post event to avoid messing with buffer before formatting
        -- process has finished (which will cancel the formatter)
        vim.api.nvim_create_autocmd("User", {
            pattern = "FormatterPost",
            callback = function()
                -- strip any whitespace not caught by formatters
                require("tidy").run()
            end,
        })
    end,
}
