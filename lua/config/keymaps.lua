local U = require("config.utils")

---Keymaps to be set by `config.utils.set_config_keymap`
local M = {}

-- set leader keys before anything else
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

---Emulate pressing Ctrl_I since this usually is <Tab> in most terminals
local function ctrl_i()
    local count = vim.v.count or 0
    if count == 0 then
        count = 1
    end
    vim.cmd('execute "normal! ' .. count .. '\\<C-i>"')
end

M.default = {
    -- adjust commonly used keys
    { "<esc>", "<cmd>noh<cr><esc>" }, -- clear search highlight
    { "<M-[>", [[<C-\><C-n>]], nil, mode = "t" }, -- exit insert in terminal mode
    { "x", '"_x', nil, mode = { "n", "x" } }, -- no register for single delete
    { "<del>", '"_x', nil, mode = { "n", "x" } }, -- no register for single delete

    -- general editor shortcuts
    { "<C-v>", "<C-r>+", "Paste from clipboard", mode = "i" },
    { "<C-a>", "ggVG", "Select all text" },
    { "<C-a>", "<esc><esc>ggVG", "Select all text", mode = { "i", "x" } },
    { "<Tab>", ">>", "Indent the current line" },
    { "<S-tab>", "<<", "Dedent the current line" },
    { "<S-tab>", "<C-d>", "Dedent the current line", mode = "i" },
    { "<Tab>", ">gv", "Indent selected lines", mode = "x" },
    { "<S-tab>", "<gv", "Indent selected lines", mode = "x" },
    { "<M-BS>", "<C-w>", "Delete the word before the cursor", mode = "i" },
    { "+", "<C-a>", "Increment number under cursor" },
    { "-", "<C-x>", "Decrement number under cursor" },
    { "<leader>I", vim.show_pos, "Same as :Inspect" },
    { "<leader>zz", toggle_foldcolumn, "Toggle fold column" },
    { "<leader>e", "<cmd>Explore<cr>", "Open file explorer" }, -- typically overwritten by plugins

    -- manipulate lines
    { "<C-Up>", "<cmd>m-2<cr>", "Move current line up" },
    { "<C-Down>", "<cmd>m+1<cr>", "Move current line down" },
    { "<C-Up>", "<esc><esc><cmd>m-2<cr>gi", "Move current line up", mode = "i" },
    { "<C-Down>", "<esc><esc><cmd>m+<cr>gi", "Move current line down", mode = "i" },
    { "<C-d>", 'm`"zyy"zpqzq``j', "Duplicate current line" },
    { "<C-d>", '<esc><esc>"zyy"zpqzqgi<C-o>j', "Duplicate current line", mode = "i" },
    { "<C-d>", '"zy"zPqzqgv', "Duplicate selected lines", mode = "x" },

    -- buffers
    { "[b", "bprev", "Go to previous buffer", dot = true },
    { "]b", "bnext", "Go to next buffer", dot = true },
    { "<leader>q", "<cmd>confirm q<cr>", "Quit the current window with confirmation" },
    { "<leader>w", ":w<cr>", "Write the current buffer" },
    { "<leader>W", ":noa w<cr>", "Write the current buffer without triggering autocommands" },
    { "<leader><leader>", swap_last_buffer, "Swap to the last buffer" },

    -- tabs
    { "[t", "tabp", "Got to previous tab", dot = true },
    { "]t", "tabn", "Got to next tab", dot = true },
    { "<leader>tt", "<cmd>tabnew<cr>", "Create a new tab" },
    { "<leader>tq", "<cmd>tabclose<cr>", "Close the current tab" },

    -- window management
    { "<leader>s=", "<C-w>=", "Make splits equal width" },
    { "<S-Up>", "<C-w>+", "Increase window height" },
    { "<S-Down>", "<C-w>-", "Decrease window height" },
    { "<S-Left>", "<C-w><", "Decrease window width" },
    { "<S-Right>", "<C-w>>", "Increase window width" },
    {
        "<M-Left>",
        "<cmd>wincmd h<cr>",
        "Move to the window left of the current one",
        mode = { "n", "t" },
    },
    {
        "<M-Right>",
        "<cmd>wincmd l<cr>",
        "Move to the window right of the current one",
        mode = { "n", "t" },
    },
    {
        "<M-Up>",
        "<cmd>wincmd k<cr>",
        "Move to the window above the current one",
        mode = { "n", "t" },
    },
    {
        "<M-Down>",
        "<cmd>wincmd j<cr>",
        "Move to the window below the current one",
        mode = { "n", "t" },
    },
    {
        "<C-h>",
        "<cmd>wincmd h<cr>",
        "Move to the window left of the current one",
        mode = { "n", "t" },
    },
    {
        "<C-l>",
        "<cmd>wincmd l<cr>",
        "Move to the window right of the current one",
        mode = { "n", "t" },
    },
    {
        "<C-k>",
        "<cmd>wincmd k<cr>",
        "Move to the window above the current one",
        mode = { "n", "t" },
    },
    {
        "<C-j>",
        "<cmd>wincmd j<cr>",
        "Move to the window below the current one",
        mode = { "n", "t" },
    },
    {
        "<C-S-Left>",
        "<cmd>wincmd H<cr>",
        "Move the window to the very left",
        mode = { "n", "t" },
    },
    {
        "<C-S-Right>",
        "<cmd>wincmd L<cr>",
        "Move the window to the very right",
        mode = { "n", "t" },
    },
    { "<C-S-Up>", "<cmd>wincmd K<cr>", "Move the window to the very top", mode = { "n", "t" } },
    {
        "<C-S-Down>",
        "<cmd>wincmd J<cr>",
        "Move the window to the very bottom",
        mode = { "n", "t" },
    },

    -- diagnostic keymaps
    {
        "[d",
        function()
            vim.diagnostic.jump({ count = -1, float = true })
        end,
        "Go to previous diagnostic",
        dot = true,
    },
    {
        "]d",
        function()
            vim.diagnostic.jump({ count = 1, float = true })
        end,
        "Go to next diagnostic",
        dot = true,
    },

    -- improve gx functionality
    {
        "gx",
        function()
            gx_ext(vim.fn.expand("<cWORD>"), old_gx_n.callback)
        end,
        "Open file, URI, or plugin under cursor in system handler",
    },
    {
        "gx",
        function()
            local lines =
                vim.fn.getregion(vim.fn.getpos("."), vim.fn.getpos("v"), { type = vim.fn.mode() })
            local value = table.concat(vim.iter(lines):map(vim.trim):totable())
            gx_ext(value, old_gx_x.callback)
        end,
        "Open selected file, URI, or plugin in system handler",
        mode = "x",
    },

    -- fix ctrl-i, map to ctrl-p
    { "<C-p>", ctrl_i, "Jump forward in jump list" },

    -- external processes
    {
        "<leader>vs",
        function()
            U.spawn_with_buf("code")
        end,
        "Open current file in vscode",
    },
}

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

M.lsp = {
    { "<leader>ih", toggle_inlay_hints, "Toggle inlay hints" },
    { "<F2>", vim.lsp.buf.rename, "Rename symbol" },
    { "<C-s>", vim.lsp.buf.signature_help, "Show signature information", mode = { "n", "i" } },
    {
        "K",
        function()
            vim.lsp.buf.hover({ border = "single" })
        end,
        "Display information for the symbol under the cursor",
    },
    {
        "gd",
        function()
            vim.lsp.buf.definition({ on_list = on_list })
        end,
        "Go to definition",
    },
    {
        "gD",
        function()
            vim.lsp.buf.declaration({ on_list = on_list })
        end,
        "Go to declaration",
    },
    {
        "gri",
        function()
            vim.lsp.buf.implementation({ on_list = on_list })
        end,
        "Go to implementation",
    },
    {
        "grr",
        function()
            vim.lsp.buf.references(nil, { on_list = on_list })
        end,
        "Go to reference",
    },
}

M.fugitive = {
    { "<leader>gs", "<cmd>G<cr>", "Open git status" },
    { "<leader>gd", "<cmd>Gdiffsplit<cr>", "Open current file git diff" },
    { "<leader>gD", "<cmd>Git diff --staged<cr>", "Open git diff for staged files" },
    { "<leader>gb", "<cmd>Git blame<cr>", "Open current file git blame" },
    { "<leader>ga", "<cmd>Git add %<cr>", "Stage current file" },
    { "<leader>gu", "<cmd>Git restore --staged %<cr>", "Unstage current file" },
    { "<leader>gr", "<cmd>Gread<cr>", "Reset current file (discard all changes)" },
    {
        "<leader>gx",
        "<cmd>GBrowse<cr>",
        "Open the current git object in browser at upstream host",
    },
}

M.fugitive_index = {
    { "a", "<cmd>norm -<cr>", "Stage or unstage the file or hunk under the cursor" },
    { "A", "<cmd>Git add -A<cr>", "Stage all files" },
    {
        "<leader>gp",
        function()
            U.confirm_yn("Push to remote?", function()
                vim.cmd("Git push")
            end)
        end,
        "Push to remote",
    },
    {
        "<leader>gP",
        function()
            U.confirm_yn("Force push to remote?", function()
                vim.cmd("Git push --force")
            end)
        end,
        "Force push to remote",
    },
}

M.gitsigns = {
    {
        "<leader>hr",
        function()
            require("gitsigns").reset_hunk()
        end,
        "Reset git hunk",
    },
    {
        "<leader>ha",
        function()
            require("gitsigns").stage_hunk()
        end,
        "Stage git hunk",
    },
    {
        "<leader>hh",
        function()
            require("gitsigns").preview_hunk()
        end,
        "View hunk diff",
    },
    {
        "<leader>hi",
        function()
            require("gitsigns").preview_hunk_inline()
        end,
        "View inline hunk diff",
    },
    {
        "<leader>hb",
        function()
            require("gitsigns").blame_line()
        end,
        "View git blame for current line",
    },
}

M.illuminate = {
    {
        "[r",
        function()
            require("illuminate").goto_prev_reference(true)
        end,
        "Go to previous hover reference",
        dot = true,
    },
    {
        "]r",
        function()
            require("illuminate").goto_next_reference(true)
        end,
        "Go to next hover reference",
        dot = true,
    },
}

M.telescope = {
    { "<leader>ff", "<cmd>Telescope find_files<cr>", "Go to file" },
    { "<leader>f/", "<cmd>Telescope live_grep<cr>", "Find in files" },
    {
        "<leader>fb",
        "<cmd>Telescope buffers sort_mru=true sort_lastused=true ignore_current_buffer=true<cr>",
        "Go to buffer",
    },
    { "<leader>fo", "<cmd>Telescope lsp_document_symbols<cr>", "Go to buffer" },
    { "<leader>fO", "<cmd>Telescope lsp_workspace_symbols<cr>", "Go to buffer" },
    { "<leader>fd", "<cmd>Telescope diagnostics<cr>", "Go to diagnostics" },
    { "<leader>fk", "<cmd>Telescope keymaps<cr>", "Search keymaps" },
    { "<leader>fgs", "<cmd>Telescope git_status<cr>", "Find dirty files" },
    { "<leader>fgc", "<cmd>Telescope git_commits<cr>", "Find git commits" },
    { "<leader>fgb", "<cmd>Telescope git_branches<cr>", "Find git branches" },
    { "<leader>f;", "<cmd>Telescope commands<cr>", "Search commands" },
    { "<leader>fhl", "<cmd>Telescope highlights<cr>", "Search highlight groups" },
    { "<leader>fcs", "<cmd>Telescope colorscheme<cr>", "Select colorscheme" },
    { "<F1>", "<cmd>Telescope help_tags<cr>", "Search help tags" },
}

M.term = {
    {
        "<Esc>",
        "<cmd>q<cr>",
        "Close integrated terminal",
        mode = "t",
    },
}

return M
