local U = require("user.utils")
local kmap = U.kmap
local nmap = U.nmap
local imap = U.imap
local vmap = U.vmap

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- adjust commonly used keys
nmap("<esc>", "<cmd>noh<cr><esc>") -- clear search highlight
kmap("t", "<M-[>", [[<C-\><C-n>]]) -- exit insert in terminal mode
kmap({ "n", "x" }, "x", '"_x') -- no register for single delete
kmap({ "n", "x" }, "<del>", '"_x') -- no register for single delete

-- general editor shortcuts
imap("<C-v>", "<C-r>+", "Paste from clipboard")
nmap("<C-a>", "ggVG", "Select all text")
kmap({ "i", "v" }, "<C-a>", "<esc><esc>ggVG", "Select all text")
nmap("<Tab>", ">>", "Indent the current line")
nmap("<S-tab>", "<<", "Dedent the current line")
imap("<S-tab>", "<C-d>", "Dedent the current line")
vmap("<Tab>", ">gv", "Indent selected lines")
vmap("<S-tab>", "<gv", "Indent selected lines")
imap("<M-BS>", "<C-w>", "Delete the word before the cursor")
nmap("+", "<C-a>", "Increment number under cursor")
nmap("-", "<C-x>", "Decrement number under cursor")
nmap("<leader>I", vim.show_pos, "Show all the items at a given buffer position (same as :Inspect)")
nmap("<leader>zz", U.toggle_foldcolumn, "Toggle fold column")

-- manipulate lines
nmap("<C-Up>", "<cmd>m-2<cr>", "Move current line up")
nmap("<C-Down>", "<cmd>m+1<cr>", "Move current line down")
imap("<C-Up>", "<esc><esc><cmd>m-2<cr>gi", "Move current line up")
imap("<C-Down>", "<esc><esc><cmd>m+<cr>gi", "Move current line down")
nmap("<C-d>", 'm`"zyy"zpqzq``j', "Duplicate current line")
imap("<C-d>", '<esc><esc>"zyy"zpqzqgi<C-o>j', "Duplicate current line")
vmap("<C-d>", '"zy"zPqzqgv', "Duplicate selected lines")

-- buffers
U.repeat_nmap("[b", function()
    vim.cmd.bp()
end, "Go to previous buffer")
U.repeat_nmap("]b", function()
    vim.cmd.bn()
end, "Go to next buffer")
nmap("<leader>q", ":confirm q<cr>", "Quit the current buffer with confirmation", { silent = true })
nmap("<C-q>", ":confirm qall<cr>", "Quit all buffers with a confirmation")
nmap("<leader>w", ":w<cr>", "Write the current buffer")
nmap("<leader>W", ":noa w<cr>", "Write the current buffer without triggering autocommands")
nmap("<leader><leader>", U.swap_last_buffer, "Swap to the last buffer if it is visible and listed")

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
kmap({ "n", "t" }, "<M-Left>", "<cmd>wincmd h<cr>", "Move to the window left of the current one")
kmap({ "n", "t" }, "<M-Right>", "<cmd>wincmd l<cr>", "Move to the window right of the current one")
kmap({ "n", "t" }, "<M-Up>", "<cmd>wincmd k<cr>", "Move to the window above the current one")
kmap({ "n", "t" }, "<M-Down>", "<cmd>wincmd j<cr>", "Move to the window below the current one")
kmap({ "n", "t" }, "<C-h>", "<cmd>wincmd h<cr>", "Move to the window left of the current one")
kmap({ "n", "t" }, "<C-l>", "<cmd>wincmd l<cr>", "Move to the window right of the current one")
kmap({ "n", "t" }, "<C-k>", "<cmd>wincmd k<cr>", "Move to the window above the current one")
kmap({ "n", "t" }, "<C-j>", "<cmd>wincmd j<cr>", "Move to the window below the current one")
kmap({ "n", "t" }, "<C-S-Left>", "<cmd>wincmd H<cr>", "Move the window to the very left")
kmap({ "n", "t" }, "<C-S-Right>", "<cmd>wincmd L<cr>", "Move the window to the very right")
kmap({ "n", "t" }, "<C-S-Up>", "<cmd>wincmd K<cr>", "Move the window to the very top")
kmap({ "n", "t" }, "<C-S-Down>", "<cmd>wincmd J<cr>", "Move the window to the very bottom")

-- diagnostic keymaps
U.repeat_nmap("[d", function()
    vim.diagnostic.goto_prev({ float = true })
end, "Go to previous diagnostic")
U.repeat_nmap("]d", function()
    vim.diagnostic.goto_next({ float = true })
end, "Go to next diagnostic")

---Extends `gx` to recognize short plugin strings (`"foo/bar"`) and open with lazy.nvim `url_format`.
---@param value string
---@param fallback function
local function gx_ext(value, fallback)
    local repo = value:match("^[\"']([%a_%.%-]+/[%a_%.%-]+)[\"']$")
    if repo then
        local url_fmt = require("lazy.core.config").options.git.url_format:gsub("%.git$", "")
        vim.ui.open(url_fmt:format(repo))
    elseif fallback then
        fallback()
    end
end

-- save original gx to use as fallback
local old_gx_n = vim.fn.maparg("gx", "n", nil, true)
local old_gx_x = vim.fn.maparg("gx", "x", nil, true)

nmap("gx", function()
    gx_ext(vim.fn.expand("<cWORD>"), old_gx_n.callback)
end, "Open file, URI, or plugin under cursor in system handler")
vmap("gx", function()
    local lines = vim.fn.getregion(vim.fn.getpos("."), vim.fn.getpos("v"), { type = vim.fn.mode() })
    local value = table.concat(vim.iter(lines):map(vim.trim):totable())
    gx_ext(value, old_gx_x.callback)
end, "Open selected file, URI, or plugin in system handler")

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
    U.spawn_with_buf("code")
end, "Open current file in vscode")
