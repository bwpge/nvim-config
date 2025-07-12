local U = require("config.utils")
local kmap = U.kmap
local nmap = U.nmap
local imap = U.imap
local vmap = U.vmap

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local function toggle_foldcolumn()
    local f = vim.o.foldcolumn

    if not f or (f and f == "0") then
        vim.o.foldcolumn = "auto:9"
    else
        vim.o.foldcolumn = "0"
    end
end

---Swaps to the last buffer with some sanity checks
local function swap_last_buffer()
    -- check if current buffer is valid, don't bother swapping if not
    local curr = vim.fn.bufnr("%")
    if curr < 0 or vim.fn.bufexists(curr) == 0 or vim.fn.buflisted(curr) ~= 1 then
        return
    end

    -- swap only if last buffer is valid and listed
    local last = vim.fn.bufnr("#")
    if last > 0 and vim.fn.bufexists(last) == 1 and vim.fn.buflisted(last) == 1 then
        vim.cmd(string.format("b%d", last))
    end
end

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
nmap("<leader>zz", toggle_foldcolumn, "Toggle fold column")
nmap("<leader>e", "<cmd>Explore<cr>", "Open file explorer") -- typically overwritten by plugins

-- manipulate lines
nmap("<C-Up>", "<cmd>m-2<cr>", "Move current line up")
nmap("<C-Down>", "<cmd>m+1<cr>", "Move current line down")
imap("<C-Up>", "<esc><esc><cmd>m-2<cr>gi", "Move current line up")
imap("<C-Down>", "<esc><esc><cmd>m+<cr>gi", "Move current line down")
nmap("<C-d>", 'm`"zyy"zpqzq``j', "Duplicate current line")
imap("<C-d>", '<esc><esc>"zyy"zpqzqgi<C-o>j', "Duplicate current line")
vmap("<C-d>", '"zy"zPqzqgv', "Duplicate selected lines")

-- buffers
U.repeat_nmap("[b", "bprev", "Go to previous buffer")
U.repeat_nmap("]b", "bnext", "Go to next buffer")
nmap("<leader>q", ":confirm q<cr>", "Quit the current buffer with confirmation", { silent = true })
nmap("<C-q>", ":confirm qall<cr>", "Quit all buffers with a confirmation")
nmap("<leader>w", ":w<cr>", "Write the current buffer")
nmap("<leader>W", ":noa w<cr>", "Write the current buffer without triggering autocommands")
nmap("<leader><leader>", swap_last_buffer, "Swap to the last buffer if it is visible and listed")

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
    vim.diagnostic.jump({ count = -1, float = true })
end, "Go to previous diagnostic")
U.repeat_nmap("]d", function()
    vim.diagnostic.jump({ count = 1, float = true })
end, "Go to next diagnostic")

---Extends `gx` to recognize short plugin strings (`"foo/bar"`) and open with lazy.nvim `url_format`.
---@param value string
---@param fallback function
local function gx_ext(value, fallback)
    local repo = value:match("^[\"'](%a[%a%d_%.%-]*/%a[%a%d_%.%-]*)[\"']")
    if repo then
        local url_fmt = require("lazy.core.config").options.git.url_format:gsub("%.git$", "")
        local url = url_fmt:format(repo)
        U.info("Opening: %s", url)
        vim.ui.open(url)
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

local function toggle_inlay_hints()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end

-- function to open the appropriate quickfix list based on installed plugins
local function on_list(options)
    -- vim.print(options)
    if #options.items == 1 then
        local item = options.items[1]
        vim.schedule(function()
            vim.cmd(string.format("e %s | call cursor(%d, %d)", item.filename, item.lnum, item.col))
        end)
        return
    end

    local qf_cmd = ""
    if vim.fn.exists(":Trouble") == 0 then
        qf_cmd = "copen"
    else
        qf_cmd = "Trouble qflist"
    end

    vim.fn.setqflist({}, " ", options)
    vim.cmd("botright " .. qf_cmd)
end

-- export keymaps that need to be setup elsewhere
return {
    lsp = {
        { "n", "<leader>ih", toggle_inlay_hints, "Toggle inlay hints" },
        { "n", "<F2>", vim.lsp.buf.rename, "Rename symbol" },
        { { "n", "i" }, "<C-s>", vim.lsp.buf.signature_help, "Show signature information" },
        {
            "n",
            "K",
            function()
                vim.lsp.buf.hover({ border = "single" })
            end,
            "Display information for the symbol under the cursor",
        },
        {
            "n",
            "gd",
            function()
                vim.lsp.buf.definition({ on_list = on_list })
            end,
            "Go to definition",
        },
        {
            "n",
            "gD",
            function()
                vim.lsp.buf.declaration({ on_list = on_list })
            end,
            "Go to declaration",
        },
        {
            "n",
            "gri",
            function()
                vim.lsp.buf.implementation({ on_list = on_list })
            end,
            "Go to implementation",
        },
        {
            "n",
            "grr",
            function()
                vim.lsp.buf.references(nil, { on_list = on_list })
            end,
            "Go to reference",
        },
    },
    fugitive = {
        { "n", "<leader>gs", "<cmd>G<cr>", "Open git status" },
        { "n", "<leader>gd", "<cmd>Gdiffsplit<cr>", "Open current file git diff" },
        { "n", "<leader>gD", "<cmd>Git diff --staged<cr>", "Open git diff for staged files" },
        { "n", "<leader>gb", "<cmd>Git blame<cr>", "Open current file git blame" },
        { "n", "<leader>ga", "<cmd>Git add %<cr>", "Stage current file" },
        { "n", "<leader>gu", "<cmd>Git restore --staged %<cr>", "Unstage current file" },
        { "n", "<leader>gr", "<cmd>Gread<cr>", "Reset current file (discard all changes)" },
        {
            "n",
            "<leader>gx",
            "<cmd>GBrowse<cr>",
            "Open the current git object in browser at upstream host",
        },
    },
    fugitive_index = {
        { "n", "a", "<cmd>norm -<cr>", "Stage or unstage the file or hunk under the cursor" },
        { "n", "A", "<cmd>Git add -A<cr>", "Stage all files" },
        {
            "n",
            "<leader>gp",
            function()
                U.confirm_yn("Push to remote?", function()
                    vim.cmd("Git push")
                end)
            end,
            "Push to remote",
        },
        {
            "n",
            "<leader>gP",
            function()
                U.confirm_yn("Force push to remote?", function()
                    vim.cmd("Git push --force")
                end)
            end,
            "Force push to remote",
        },
    },
    gitsigns = {
        {
            "n",
            "<leader>hr",
            function()
                require("gitsigns").reset_hunk()
            end,
            "Reset git hunk",
        },
        {
            "n",
            "<leader>ha",
            function()
                require("gitsigns").stage_hunk()
            end,
            "Stage git hunk",
        },
        {
            "n",
            "<leader>hh",
            function()
                require("gitsigns").preview_hunk()
            end,
            "View hunk diff",
        },
        {
            "n",
            "<leader>hi",
            function()
                require("gitsigns").preview_hunk_inline()
            end,
            "View inline hunk diff",
        },
        {
            "n",
            "<leader>hb",
            function()
                require("gitsigns").blame_line()
            end,
            "View git blame for current line",
        },
    },
    term = {
        {
            "t",
            "<Esc>",
            "<cmd>q<cr>",
            "Close integrated terminal",
        },
    },
}
