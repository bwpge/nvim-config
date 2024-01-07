local opt = vim.opt

-- use unix line endings by default
opt.fileformat = "unix"
opt.fileformats = "unix,dos"

-- line numbers
opt.relativenumber = true
opt.number = true

-- tabs/indents
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

-- editor settings
opt.wrap = false
opt.termguicolors = true
opt.background = 'dark'
opt.signcolumn = 'yes'
opt.cursorline = true

-- searching
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

-- proper backspace behavior
opt.backspace = 'indent,eol,start'

-- allow arrow keys to wrap lines
opt.whichwrap:append('<,>,[,]')

-- clipboard
opt.clipboard:append('unnamedplus')

-- window splits
opt.splitright = true
opt.splitbelow = true

-- timings
-- opt.timoutlen = 500 -- ms for mapped sequence to complete
opt.updatetime = 300 -- ms before completion and diagnostics

-- misc
opt.iskeyword:append('-') -- consider '-' part of a word
opt.completeopt = 'menu,menuone,noselect'
opt.showmode = false -- don't show mode in message bar

-- rust options (:h RustFmt)
vim.g.rustfmt_autosave = 1
vim.g.rustfmt_emit_files = 1
vim.g.rustfmt_fail_silently = 0

-- highlight yanked text
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank({ timeout = 200 })
    end,
})
