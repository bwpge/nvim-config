local utils = require("user.utils")
local kmap = utils.kmap
local nmap = utils.nmap
local imap = utils.imap
local vmap = utils.vmap

vim.g.mapleader = " "

-- adjust commonly used keys
nmap("<esc>", "<cmd>noh<cr><esc>") -- clear search highlight
kmap("t", "<M-[>", [[<C-\><C-n>]]) -- exit insert in terminal mode
kmap({ "n", "x" }, "x", '"_x') -- no register for single delete
kmap({ "n", "x" }, "<del>", '"_x') -- no register for single delete

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
nmap("<M-+>", "<C-a>", "Increment number under cursor")
nmap("<M-_>", "<C-x>", "Decrement number under cursor")
nmap("<leader>I", vim.show_pos, "Show all the items at a given buffer position (same as :Inspect)")

-- manipulate lines
nmap("<C-up>", "<cmd>m-2<cr>", "Move current line up")
nmap("<C-down>", "<cmd>m+1<cr>", "Move current line down")
imap("<C-up>", "<esc><esc><cmd>m-2<cr>gi", "Move current line up")
imap("<C-down>", "<esc><esc><cmd>m+<cr>gi", "Move current line down")
nmap("<C-d>", 'm`"zyy"zpqzq``j', "Duplicate current line")
imap("<C-d>", '<esc><esc>"zyy"zpqzqgi<C-o>j', "Duplicate current line")
vmap("<C-d>", '"zy"zPqzqgv', "Duplicate selected lines")

-- buffers
nmap("[b", "<cmd>bp<cr>", "Go to previous buffer")
nmap("]b", "<cmd>bn<cr>", "Go to next buffer")
nmap("<leader>q", ":confirm q<cr>", "Quit the current buffer with confirmation", { silent = true })
nmap("<C-q>", ":confirm qall<cr>", "Quit all buffers with a confirmation")
nmap("<leader>w", ":w<cr>", "Write the current buffer")
nmap("<leader>W", ":noa w<cr>", "Write the current buffer without triggering autocommands")
nmap(
    "<leader><leader>",
    utils.swap_last_buffer,
    "Swap to the last buffer if it is visible and listed"
)

-- tabs
nmap("[t", "<cmd>tabp<cr>", "Got to previous tab")
nmap("]t", "<cmd>tabn<cr>", "Got to next tab")
nmap("<leader>tt", "<cmd>tabnew<cr>", "Create a new tab")
nmap("<leader>tq", "<cmd>tabclose<cr>", "Close the current tab")

-- window management
nmap("<leader>sv", "<cmd>vert new<cr>", "Split vertically with a new buffer")
nmap("<leader>sh", "<cmd>new<cr>", "Split horizontally with a new buffer (same as :new)")
nmap("<leader>ss", "<cmd>split<cr>", "Split current buffer")
nmap("<leader>s=", "<C-w>=", "Make splits equal width")
nmap("<S-Up>", "<C-w>+", "Increase window height")
nmap("<S-Down>", "<C-w>-", "Decrease window height")
nmap("<S-Left>", "<C-w><", "Decrease window width")
nmap("<S-Right>", "<C-w>>", "Increase window width")
kmap({ "n", "t" }, "<M-left>", "<cmd>wincmd h<cr>", "Move to the window left of the current one")
kmap({ "n", "t" }, "<M-right>", "<cmd>wincmd l<cr>", "Move to the window right of the current one")
kmap({ "n", "t" }, "<M-up>", "<cmd>wincmd k<cr>", "Move to the window above the current one")
kmap({ "n", "t" }, "<M-down>", "<cmd>wincmd j<cr>", "Move to the window below the current one")
kmap({ "n", "t" }, "<C-h>", "<cmd>wincmd h<cr>", "Move to the window left of the current one")
kmap({ "n", "t" }, "<C-l>", "<cmd>wincmd l<cr>", "Move to the window right of the current one")
kmap({ "n", "t" }, "<C-k>", "<cmd>wincmd k<cr>", "Move to the window above the current one")
kmap({ "n", "t" }, "<C-j>", "<cmd>wincmd j<cr>", "Move to the window below the current one")
kmap({ "n", "t" }, "<C-S-left>", "<cmd>wincmd H<cr>", "Move the window to the very left")
kmap({ "n", "t" }, "<C-S-right>", "<cmd>wincmd L<cr>", "Move the window to the very right")
kmap({ "n", "t" }, "<C-S-up>", "<cmd>wincmd K<cr>", "Move the window to the very top")
kmap({ "n", "t" }, "<C-S-down>", "<cmd>wincmd J<cr>", "Move the window to the very bottom")

-- diagnostic keymaps
nmap("[d", function()
    vim.diagnostic.goto_prev({ float = true })
end, "Go to previous diagnostic")
nmap("]d", function()
    vim.diagnostic.goto_next({ float = true })
end, "Go to next diagnostic")

-- extend gx to recognize short plugin strings
local old_gx = vim.fn.maparg("gx", "n", nil, true)
nmap("gx", utils.gx_extended_fn(old_gx.callback), old_gx.desc)

-- fix <C-i> since this sends the same keycode as <Tab>
local function ctrl_i()
    local count = vim.v.count or 0
    if count == 0 then
        count = 1
    end
    vim.cmd('execute "normal! ' .. count .. '\\<C-i>"')
end
nmap("<C-p>", ctrl_i, "Jump forward in jump list")

-- external processes
nmap("<leader>vs", function()
    utils.spawn_with_buf("code")
end, "Open current file in vscode")
