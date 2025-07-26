local U = require("config.utils")

vim.wo.wrap = true

-- simplify code blocks
U.imap("```", "```<cr>```<esc>kA", "")
