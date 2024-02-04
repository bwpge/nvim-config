local utils = require("user.utils")
local km = utils.km

vim.g.mapleader = " "

-- adjust commonly used keys
km("n", "<esc>", "<cmd>noh<cr><esc>") -- clear search highlight
km({ "n", "v" }, "x", '"_x') -- no register for single delete
km({ "n", "v" }, "<del>", '"_x') -- no register for single delete

-- general editor shortcuts
km("i", "<C-v>", "<C-r>+", "Paste from clipboard")
km("n", "<C-a>", "ggVG", "Select all text")
km({ "i", "v" }, "<C-a>", "<esc><esc>ggVG", "Select all text")
km("n", "<tab>", ">>", "Indent the current line")
km("n", "<S-tab>", "<<", "Dedent the current line")
km("i", "<S-tab>", "<C-d>", "Dedent the current line")
km("v", "<tab>", ">gv", "Indent selected lines")
km("v", "<S-tab>", "<gv", "Indent selected lines")
km("n", "<S-Up>", "kzz", "Move cursor up and center view")
km("n", "<S-Down>", "jzz", "Move cursor down and center view")
km("n", "<M-=>", "<C-a>", "Increment number under cursor")
km("n", "<M-->", "<C-x>", "Decrement number under cursor")

-- manipulate lines
km("n", "<C-up>", "<cmd>m-2<cr>", "Move current line up")
km("n", "<C-down>", "<cmd>m+1<cr>", "Move current line down")
km("i", "<C-up>", "<esc><esc><cmd>m-2<cr>gi", "Move current line up")
km("i", "<C-down>", "<esc><esc><cmd>m+<cr>gi", "Move current line down")
km("n", "<C-d>", 'm`"zyy"zpqzq``j', "Duplicate current line")
km("i", "<C-d>", '<esc><esc>"zyy"zpqzqgi<C-o>j', "Duplicate current line")
km("v", "<C-d>", '"zy"zPqzqgv', "Duplicate selected lines")

-- buffer shortcuts
km("n", "<leader>q", ":confirm q<cr>", "Quit the current buffer with confirmation")
km("n", "<C-q>", ":confirm qall<cr>", "Quit all buffers with a confirmation")
km("n", "<leader>w", ":w<cr>", "Write the current buffer")
km(
    "n",
    "<leader><leader>",
    utils.swap_last_buffer,
    "Swap to the last buffer if it is visible and listed"
)

-- window management
km("n", "<leader>sv", "<cmd>vert new<cr>", "Split vertically with a new buffer")
km("n", "<leader>sh", "<cmd>new<cr>", "Split horizontally with a new buffer")
km("n", "<leader>ss", "<cmd>split<cr>", "Split current buffer")
km("n", "<leader>sn", "<C-w>n", "Split to new window")
km("n", "<leader>s=", "<C-w>=", "Make splits equal width")
km("n", "<leader><Up>", "<C-w>+", "Increase window height")
km("n", "<leader><Down>", "<C-w>-", "Decrease window height")
local win_nav = {
    ["<M-left>"] = { "<cmd>wincmd h<cr>", "Move to the window left of the current one" },
    ["<M-right>"] = { "<cmd>wincmd l<cr>", "Move to the window right of the current one" },
    ["<M-up>"] = { "<cmd>wincmd k<cr>", "Move to the window above the current one" },
    ["<M-down>"] = { "<cmd>wincmd j<cr>", "Move to the window below the current one" },
}
for lhs, item in pairs(win_nav) do
    ---@diagnostic disable-next-line: deprecated
    local rhs, desc = unpack(item)
    km("n", lhs, rhs, desc)
end

-- plugin menu
km("n", "<leader>pl", "<cmd>Lazy<cr>", "Open Lazy")
km("n", "<leader>pm", "<cmd>Mason<cr>", "Open Mason")

-- neotree
km("n", "<leader>e", "<cmd>Neotree reveal toggle<cr>")
km("n", "<leader>gs", "<cmd>Neotree float git_status toggle<cr>")

-- telescope
km("n", "<leader>ff", "<cmd>Telescope find_files<cr>", "Go to file")
km("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", "Find in files (rg regex)")
km("n", "<leader>fs", "<cmd>Telescope grep_string<cr>", "Find word under cursor")
km("n", "<leader>fb", "<cmd>Telescope buffers<cr>", "Go to buffer")
km("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>", "Go to diagnostics")
km("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", "Search keymaps")
km("n", "<leader>ft", "<cmd>TodoTelescope<cr>", "Go to todo item")
km("n", "<F1>", "<cmd>Telescope help_tags<cr>", "Search help tags")

-- formatting
km("n", "<M-F>", "<cmd>Format<cr>", "Format the current buffer")

-- external processes
km("n", "<leader>vs", function()
    utils.spawn_with_buf("code")
end, "Open current file in vscode")
