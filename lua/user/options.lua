local opt = vim.opt

-- use unix line endings by default
vim.o.fileformat = "unix"
vim.o.fileformats = "unix,dos"

-- line numbers
opt.relativenumber = true
opt.number = true

-- tabs/indents
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

-- folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.require('user.utils').foldexpr()"
vim.opt.foldtext = ""
vim.opt.foldlevel = 999
vim.opt.foldlevelstart = 999

-- editor settings
opt.background = "dark"
opt.cursorline = true
opt.fillchars:append({
    eob = " ",
    fold = " ",
    foldopen = "",
    foldclose = "",
})
opt.list = true
opt.listchars:append({
    tab = "→ ",
    trail = "•",
})
opt.mousemodel = "extend"
opt.pumheight = 15
opt.scrolloff = 4
opt.signcolumn = "yes"
opt.termguicolors = true
opt.wrap = false

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

-- misc
opt.iskeyword:append("-") -- consider '-' part of a word
opt.completeopt = "menu,menuone,noselect"
opt.showmode = false -- don't show mode in message bar

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
