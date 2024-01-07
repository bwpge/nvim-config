vim.g.mapleader = ' '

local km = vim.keymap
local opts = { noremap = true, silent = true }

-- disable default keymaps
km.set('n', '<F1>', '<nop>', opts)
km.set('i', '<F1>', '<nop>', opts)

-- clear search highlight with esc
km.set('n', '<esc>', '<cmd>noh<cr><esc>', opts)

-- paste with ctrl+v in insert mode
km.set('i', '<C-v>', '<C-r>+', opts)

-- better home key
km.set('n', '<C-home>', 'gg0', opts)
km.set('i', '<home>', '<esc><esc>^i', opts)

-- select all
km.set('n', '<C-a>', 'ggVG', opts)

-- tab and shift+tab behavior
km.set('n', '<tab>', '>>', opts)
km.set('n', '<S-tab>', '<<', opts)
km.set('i', '<S-tab>', '<C-d>', opts)
km.set('v', '<tab>', '>gv', opts) -- indent and keep selection
km.set('v', '<S-tab>', '<gv', opts) -- de-indent and keep selection

-- don't put single character deletes in the register
km.set('n', 'x', '"_x', opts)
km.set('n', '<del>', '"_x', opts)

-- move lines up and down
km.set('n', '<C-up>', '<cmd>m-2<cr>', opts)
km.set('n', '<C-down>', '<cmd>m+1<cr>', opts)
km.set('i', '<C-up>', '<esc><esc><cmd>m-2<cr>gi', opts)
km.set('i', '<C-down>', '<esc><esc><cmd>m+<cr>gi', opts)

-- buffer shortcuts
km.set('n', '<leader>q', ':confirm q<cr>', opts) -- quit with prompt to save
km.set('n', '<C-q>', ':confirm qall<cr>', opts) -- quit all with prompt to save
km.set('n', '<leader>w', ':w<cr>', opts) -- write shortcut
-- km.set('n', '<leader>bd', '<cmd>Bdelete<cr>', opts) -- delete current buffer, use vim-bbye
-- km.set('n', '<leader><leader>', '<cmd>LastBufferSwap<cr>', opts)

-- window splits
km.set('n', '<leader>sv', '<cmd>vert new<cr>', opts) -- split vertical with new buffer
km.set('n', '<leader>sh', '<cmd>new<cr>', opts) -- split horizontal with new buffer
km.set('n', '<leader>sn', '<C-w>n', opts) -- new window with split
km.set('n', '<leader>s=', '<C-w>=', opts) -- make equal width

-- window navigation
local win_nav = {
    ['<M-left>'] = '<cmd>wincmd h<cr>',
    ['<M-right>'] = '<cmd>wincmd l<cr>',
    ['<M-up>'] = '<cmd>wincmd k<cr>',
    ['<M-down>'] = '<cmd>wincmd j<cr>',
}

for key, cmd in pairs(win_nav) do
    km.set('n', key, cmd, opts)
end

-- tab navigation
km.set('n', '<C-t>', '<cmd>tabnew<cr>', opts) -- new tab
km.set('n', '<leader>tn', '<cmd>tabnew<cr>', opts) -- new tab
km.set('n', '<leader>tq', '<cmd>tabclose<cr>', opts) -- close tab

-- terminal mode navigation
-- km.set('t', '<esc>', [[<C-\><C-n>]], opts)

-- NvimTree
-- km.set('n', '<leader>e', '<cmd>NvimTreeToggle<cr>', opts)

-- telescope
km.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>', opts)
km.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', opts)
km.set('n', '<leader>fs', '<cmd>Telescope grep_string<cr>', opts)
km.set('n', '<leader>fb', '<cmd>Telescope buffers<cr>', opts)
km.set('n', '<leader>fd', '<cmd>Telescope diagnostics<cr>', opts)
km.set('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', opts)
-- km.set('n', '<leader>fn', '<cmd>Telescope notify<cr>', opts)
km.set('n', '<F1>', '<cmd>Telescope help_tags<cr>', opts)
