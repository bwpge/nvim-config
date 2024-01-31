vim.g.mapleader = " "

local km = vim.keymap
local opts = { noremap = true, silent = true }

-- create a command for last buffer swapping
vim.api.nvim_create_user_command("SwapLastBuf", require("user.utils").swap_last_buffer, {})

-- disable default keymaps
km.set("n", "<F1>", "<nop>", opts)
km.set("i", "<F1>", "<nop>", opts)

-- use sane key behavior
km.set("n", "<esc>", "<cmd>noh<cr><esc>", opts) -- clear search highlight
km.set("n", "x", '"_x', opts) -- no register for single delete
km.set("n", "<del>", '"_x', opts) -- no register for single delete

-- general editor shortcuts
km.set("i", "<C-v>", "<C-r>+", opts) -- paste with ctrl+v in insert mode
km.set("n", "<C-a>", "ggVG", opts) -- select all
km.set({ "i", "v" }, "<C-a>", "<esc><esc>ggVG", opts) -- select all
km.set("n", "<tab>", ">>", opts) -- indent
km.set("n", "<S-tab>", "<<", opts) -- dedent
km.set("i", "<S-tab>", "<C-d>", opts) -- dedent in insert mode
km.set("v", "<tab>", ">gv", opts) -- indent and keep selection
km.set("v", "<S-tab>", "<gv", opts) -- dedent and keep selection
km.set("n", "<leader>e", "<cmd>Neotree reveal toggle<cr>", opts) -- neo-tree

-- manipulate lines
km.set("n", "<C-up>", "<cmd>m-2<cr>", opts) -- move line up
km.set("n", "<C-down>", "<cmd>m+1<cr>", opts) -- move line down
km.set("i", "<C-up>", "<esc><esc><cmd>m-2<cr>gi", opts) -- move line up
km.set("i", "<C-down>", "<esc><esc><cmd>m+<cr>gi", opts) -- move line down
km.set("n", "<C-d>", 'm`"zyy"zpqzq``j', opts) -- duplicate line
km.set("i", "<C-d>", '<esc><esc>"zyy"zpqzqgi<C-o>j', opts) -- duplicate line

-- buffer shortcuts
km.set("n", "<leader>q", ":confirm q<cr>", opts) -- quit with prompt to save
km.set("n", "<C-q>", ":confirm qall<cr>", opts) -- quit all with prompt to save
km.set("n", "<leader>w", ":w<cr>", opts) -- write shortcut
km.set("n", "<leader><leader>", "<cmd>SwapLastBuf<cr>", opts)

-- window splits
km.set("n", "<leader>sv", "<cmd>vert new<cr>", opts) -- split vertical with new buffer
km.set("n", "<leader>sh", "<cmd>new<cr>", opts) -- split horizontal with new buffer
km.set("n", "<leader>sn", "<C-w>n", opts) -- new window with split
km.set("n", "<leader>s=", "<C-w>=", opts) -- make equal width

-- window navigation
local win_nav = {
    ["<M-left>"] = "<cmd>wincmd h<cr>",
    ["<M-right>"] = "<cmd>wincmd l<cr>",
    ["<M-up>"] = "<cmd>wincmd k<cr>",
    ["<M-down>"] = "<cmd>wincmd j<cr>",
}
for key, cmd in pairs(win_nav) do
    km.set("n", key, cmd, opts)
end

-- plugin menu
km.set("n", "<leader>L", "<cmd>Lazy<cr>", opts)
km.set("n", "<leader>M", "<cmd>Mason<cr>", opts)

-- telescope
km.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts)
km.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts)
km.set("n", "<leader>fs", "<cmd>Telescope grep_string<cr>", opts)
km.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts)
km.set("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>", opts)
km.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts)
km.set("n", "<F1>", "<cmd>Telescope help_tags<cr>", opts)

-- formatting
km.set("n", "<M-F>", "<cmd>Format<cr>", opts)
