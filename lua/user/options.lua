local opt = vim.opt

-- use unix line endings by default
vim.o.fileformat = "unix"
vim.o.fileformats = "unix,dos"

-- line numbers
opt.relativenumber = true
opt.number = true
opt.fillchars = { eob = " " }

-- tabs/indents
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

-- editor settings
opt.mousemodel = "extend"
opt.wrap = false
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 4
opt.list = true
opt.listchars:append({
    tab = "→ ",
    trail = "•",
})

-- searching
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

-- proper backspace behavior
opt.backspace = "indent,eol,start"

-- allow arrow keys to wrap lines
opt.whichwrap:append("<,>,[,]")

-- clipboard
opt.clipboard:append("unnamedplus")

-- window splits
opt.splitright = true
opt.splitbelow = true
opt.diffopt:append("vertical")

-- timings
-- note that g:cursorhold_updatetime requires FixCursorHold.nvim plugin
-- this is used to avoid blasting the swapfile, and some plugins need it
vim.g.cursorhold_updatetime = 400
-- opt.timoutlen = 500 -- ms for mapped sequence to complete

-- misc
opt.iskeyword:append("-") -- consider '-' part of a word
opt.completeopt = "menu,menuone,noselect"
opt.showmode = false -- don't show mode in message bar

-- rust options (:h RustFmt)
vim.g.rustfmt_autosave = 1
vim.g.rustfmt_emit_files = 1
vim.g.rustfmt_fail_silently = 0

-- highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({ timeout = 200 })
    end,
})

-- lsp update in insert mode
vim.diagnostic.config({
    update_in_insert = true,
})
