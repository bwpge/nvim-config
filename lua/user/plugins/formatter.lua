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
				lua = { require("formatter.filetypes.lua").stylua },
				["*"] = function() end,
			},
		})

		local formatter_group = vim.api.nvim_create_augroup("__formatter__", { clear = true })
		local autocmd = vim.api.nvim_create_autocmd

        -- format on save
		autocmd("BufWritePost", {
			group = formatter_group,
			command = ":FormatWrite",
		})

        -- run tidy.nvim after format to avoid messing with buffer before
        -- formatting process has finished (which will cancel the formatter)
		autocmd("User", {
			pattern = "FormatterPost",
			group = formatter_group,
			callback = function()
				require("tidy").run()
			end,
		})
	end,
}
