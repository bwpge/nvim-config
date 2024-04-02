-- forward compatibility for vim.uv
vim.uv = vim.uv or vim.loop

require("user.keymaps")
require("user.options")
require("user.commands")
require("user.lazy")
