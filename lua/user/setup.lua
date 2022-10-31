-- bootstrap packer.nvim
-- see: https://github.com/wbthomason/packer.nvim

local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

-- make sure packer was loaded
local status, packer = pcall(require, 'packer')
if not status then
    error('failed to load packer!')
    return
end

-- install plugins when saving this file
vim.api.nvim_create_augroup('packer_user_config', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
    group = 'packer_user_config',
    pattern = { 'setup.lua' }, -- make it this file name
    callback = function()
        vim.cmd('source <afile> | PackerSync')
    end
})

-- use popup window for packer
packer.init({
    display = {
        open_fn = function()
            return require('packer.util').float({ border = 'single' })
        end,
    },
})

-- configure plugins
return packer.startup(function(use)
    -- required
    use('wbthomason/packer.nvim')
    use('nvim-lua/plenary.nvim')

    -- themes
    use('navarasu/onedark.nvim')
    use({ "catppuccin/nvim", as = "catppuccin" })
    use('ellisonleao/gruvbox.nvim')
    use('rmehri01/onenord.nvim')
    use('bluz71/vim-nightfly-guicolors')

    -- editor
    use('tpope/vim-surround') -- shortcuts for surrounding text
    use('numToStr/Comment.nvim') -- easy commenting with gc
    use('andymass/vim-matchup') -- jump between keywords
    use('notjedi/nvim-rooter.lua') -- change root for projects
    use('moll/vim-bbye') -- better buffer close behavior

    -- gui
    use('nvim-tree/nvim-web-devicons') -- icons, used by a couple plugins
    use('onsails/lspkind.nvim') -- vscode icons for nvim-cmp
    use({ 'nvim-lualine/lualine.nvim', requires = 'nvim-tree/nvim-web-devicons' }) -- status bar
    use('arkav/lualine-lsp-progress') -- lsp progress for lualine
    use('lewis6991/gitsigns.nvim') -- in-line git decorations
    use({ 'nvim-tree/nvim-tree.lua', requires = 'nvim-tree/nvim-web-devicons' }) -- file explorer
    use({ 'akinsho/bufferline.nvim', tag = 'v3.*', requires = 'nvim-tree/nvim-web-devicons' }) -- buffer tabs
    use('windwp/nvim-autopairs') -- autoclose brackets, quotes, etc.
    use('j-hui/fidget.nvim') -- adds lsp progress tasks above status bar
    use({ 'akinsho/toggleterm.nvim', tag = '*' }) -- integrated terminal
    use('rcarriga/nvim-notify') -- gui notifications

    -- language support
    use('rust-lang/rust.vim')

    -- language server
    use('williamboman/mason.nvim') -- manage lsp servers (must be configured before lspconfig)
    use('williamboman/mason-lspconfig.nvim') -- bridge between mason and lspconfig

    -- completion
    use('neovim/nvim-lspconfig') -- configuration for lsp
    use({ 'glepnir/lspsaga.nvim', branch = "main" }) -- polished completion experience
    use('hrsh7th/cmp-nvim-lsp') -- lsp for completion
    use('hrsh7th/cmp-buffer') -- completion from buffer
    use('hrsh7th/cmp-path') -- completion for paths
    use('hrsh7th/nvim-cmp') -- completion plugin

    -- snippets
    use({ "L3MON4D3/LuaSnip", tag = "v1.*" }) -- snippet engine required for nvim-cmp
    use('saadparwaiz1/cmp_luasnip') -- bridge luasnip and nvim-cmp
    use('rafamadriz/friendly-snippets') -- popular snippet source

    -- tree-sitter
    -- note: requires the cli to build some language support
    -- see: https://github.com/tree-sitter/tree-sitter/blob/master/cli/README.md
    use({
        'nvim-treesitter/nvim-treesitter',
        run = function()
            require('nvim-treesitter.install').update({ with_sync = true })
        end,
    })

    -- telescope fzf
    -- note: requires cmake or make to build
    -- see: https://github.com/nvim-telescope/telescope-fzf-native.nvim#installation
    local fzf_build_cmd
    if require('user.core.utils').get_build_system() == 'cmake' then
        fzf_build_cmd = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
    else
        fzf_build_cmd = 'make'
    end
    if fzf_build_cmd then
        use({ 'nvim-telescope/telescope-fzf-native.nvim', run = fzf_build_cmd })
    else
        vim.notify('telescope-fzf-native could not be loaded (no suitable build command found)', vim.log.levels.ERROR)
    end

    -- telescope
    use({ 'nvim-telescope/telescope.nvim', tag = '0.1.0', requires = 'nvim-lua/plenary.nvim' })

    if packer_bootstrap then
        require('packer').sync()
    end
end)
