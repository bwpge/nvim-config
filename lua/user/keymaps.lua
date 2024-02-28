local utils = require("user.utils")
local kmap = utils.kmap
local nmap = utils.nmap
local imap = utils.imap
local vmap = utils.vmap

vim.g.mapleader = " "

-- adjust commonly used keys
nmap("<esc>", "<cmd>noh<cr><esc>") -- clear search highlight
kmap("t", "<Esc>", [[<C-\><C-n>]]) -- exit insert in terminal mode
kmap({ "n", "v" }, "x", '"_x') -- no register for single delete
kmap({ "n", "v" }, "<del>", '"_x') -- no register for single delete

-- general editor shortcuts
imap("<C-v>", "<C-r>+", "Paste from clipboard")
nmap("<C-a>", "ggVG", "Select all text")
kmap({ "i", "v" }, "<C-a>", "<esc><esc>ggVG", "Select all text")
nmap("<tab>", ">>", "Indent the current line")
nmap("<S-tab>", "<<", "Dedent the current line")
imap("<S-tab>", "<C-d>", "Dedent the current line")
vmap("<tab>", ">gv", "Indent selected lines")
vmap("<S-tab>", "<gv", "Indent selected lines")
imap("<M-BS>", "<C-w>", "Delete the word before the cursor")
nmap("<S-Up>", "kzz", "Move cursor up and center view")
nmap("<S-Down>", "jzz", "Move cursor down and center view")
nmap("<M-=>", "<C-a>", "Increment number under cursor")
nmap("<M-->", "<C-x>", "Decrement number under cursor")
nmap("<leader>I", vim.show_pos, "Show all the items at a given buffer position (same as :Inspect)")

-- manipulate lines
nmap("<C-up>", "<cmd>m-2<cr>", "Move current line up")
nmap("<C-down>", "<cmd>m+1<cr>", "Move current line down")
imap("<C-up>", "<esc><esc><cmd>m-2<cr>gi", "Move current line up")
imap("<C-down>", "<esc><esc><cmd>m+<cr>gi", "Move current line down")
nmap("<C-d>", 'm`"zyy"zpqzq``j', "Duplicate current line")
imap("<C-d>", '<esc><esc>"zyy"zpqzqgi<C-o>j', "Duplicate current line")
vmap("<C-d>", '"zy"zPqzqgv', "Duplicate selected lines")

-- buffer shortcuts
nmap("[b", "<cmd>bp<cr>", "Go to previous buffer")
nmap("]b", "<cmd>bn<cr>", "Go to next buffer")
nmap("<leader>q", ":confirm q<cr>", "Quit the current buffer with confirmation")
nmap("<C-q>", ":confirm qall<cr>", "Quit all buffers with a confirmation")
nmap("<leader>w", ":w<cr>", "Write the current buffer")
nmap("<leader>W", ":noa w<cr>", "Write the current buffer without triggering autocommands")
nmap(
    "<leader><leader>",
    utils.swap_last_buffer,
    "Swap to the last buffer if it is visible and listed"
)

-- window management
nmap("<leader>sv", "<cmd>vert new<cr>", "Split vertically with a new buffer")
nmap("<leader>sh", "<cmd>new<cr>", "Split horizontally with a new buffer")
nmap("<leader>ss", "<cmd>split<cr>", "Split current buffer")
nmap("<leader>sn", "<C-w>n", "Split to new window")
nmap("<leader>s=", "<C-w>=", "Make splits equal width")
nmap("<leader><Up>", "<C-w>+", "Increase window height")
nmap("<leader><Down>", "<C-w>-", "Decrease window height")
local win_nav = {
    ["<M-left>"] = { "<cmd>wincmd h<cr>", "Move to the window left of the current one" },
    ["<M-right>"] = { "<cmd>wincmd l<cr>", "Move to the window right of the current one" },
    ["<M-up>"] = { "<cmd>wincmd k<cr>", "Move to the window above the current one" },
    ["<M-down>"] = { "<cmd>wincmd j<cr>", "Move to the window below the current one" },
}
for lhs, item in pairs(win_nav) do
    ---@diagnostic disable-next-line: deprecated
    local rhs, desc = unpack(item)
    nmap(lhs, rhs, desc)
end

-- plugin menu
nmap("<leader>pl", "<cmd>Lazy<cr>", "Open Lazy")
nmap("<leader>pm", "<cmd>Mason<cr>", "Open Mason")

-- neotree
nmap("<leader>e", "<cmd>Neotree reveal toggle<cr>", "Toggle Neotree file explorer")
nmap("<leader>gs", "<cmd>Neotree float git_status toggle<cr>", "Toggle Neotree git status")

-- telescope
nmap("<leader>ff", "<cmd>Telescope find_files<cr>", "Go to file")
nmap("<leader>fg", "<cmd>Telescope live_grep<cr>", "Find in files (rg regex)")
nmap("<leader>fs", "<cmd>Telescope grep_string<cr>", "Find word under cursor")
nmap("<leader>fb", "<cmd>Telescope buffers<cr>", "Go to buffer")
nmap("<leader>fd", "<cmd>Telescope diagnostics<cr>", "Go to diagnostics")
nmap("<leader>fk", "<cmd>Telescope keymaps<cr>", "Search keymaps")
nmap("<leader>fs", "<cmd>Telescope git_status<cr>", "Go to git status")
nmap("<leader>ft", "<cmd>TodoTelescope<cr>", "Go to todo item")
nmap("<F1>", "<cmd>Telescope help_tags<cr>", "Search help tags")
nmap("<leader>H", "<cmd>Telescope highlights<cr>", "Search highlight groups")

-- trouble
nmap("<leader>x", "<cmd>TroubleToggle<cr>", "Toggle problems view (trouble)")

-- formatting
nmap("<M-F>", "<cmd>Format<cr>", "Format the current buffer")

-- external processes
nmap("<leader>vs", function()
    utils.spawn_with_buf("code")
end, "Open current file in vscode")
