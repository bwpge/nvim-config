return {
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v3.x",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"neovim/nvim-lspconfig",
			"lvimuser/lsp-inlayhints.nvim",
            -- see https://github.com/rust-lang/rust.vim/issues/461
            "rust-lang/rust.vim",
		},
		config = function()
			local ih = require("lsp-inlayhints")
			ih.setup()
			local lsp_zero = require("lsp-zero")

			lsp_zero.on_attach(function(client, bufnr)
				ih.on_attach(client, bufnr)

				-- see :help lsp-zero-keybindings
				lsp_zero.default_keymaps({
					buffer = bufnr,
					exclude = { "gi", "<F3>", "<F4>" },
				})

				local opts = { buffer = bufnr }
				-- vim.keymap.set({ "n", "v" }, "<leader>F", "<cmd>lua vim.lsp.buf.format()<cr>", opts)
				vim.keymap.set("n", "<leader>.", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
				vim.keymap.set("n", "<leader>ih", function()
					require("lsp-inlayhints").toggle()
				end, opts)
			end)

			lsp_zero.set_sign_icons({
				error = "",
				warn = "",
				hint = "⚑",
				info = "",
			})

			-- see :help lsp-zero-guide:integrate-with-mason-nvim
			require("mason").setup({})
			require("mason-lspconfig").setup({
				ensure_installed = { "clangd", "lua_ls", "tsserver", "rust_analyzer" },
				handlers = {
					lsp_zero.default_setup,
					-- fix lua lsp unknown global
					lua_ls = function()
						require("lspconfig").lua_ls.setup({
							settings = {
								Lua = {
									hint = {
										enable = true,
									},
									diagnostics = {
										enable = true,
										globals = { "vim" },
									},
								},
							},
						})
					end,
				},
			})
		end,
	},
}
