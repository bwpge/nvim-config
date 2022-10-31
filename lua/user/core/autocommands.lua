local api = vim.api

-- highlight on yank, see:
--   https://neovim.io/doc/user/lua.html#lua-highlight
--   https://luabyexample.org/docs/nvim-autocmd/i
--   https://github.com/nanotee/nvim-lua-guide/issues/100#issuecomment-1055904411
api.nvim_create_augroup('yank_highlight', { clear = true })
api.nvim_create_autocmd('TextYankPost', {
    group = 'yank_highlight',
    pattern = { '*' },
    callback = function() require('vim.highlight').on_yank({
        higroup = 'IncSearch',
        timeout = 150,
    }) end
})

-- lspsaga winbar
-- see: https://github.com/glepnir/lspsaga.nvim#show-symbols-in-winbarnvim-08-or-in-statusline
local function get_file_name(include_path)
    local file_name = require('lspsaga.symbolwinbar').get_file_name()
    if vim.fn.bufname '%' == '' then return '' end
    if include_path == false then return file_name end
    local sep = vim.loop.os_uname().sysname == 'Windows' and '\\' or '/'
    local path_list = vim.split(string.gsub(vim.fn.expand '%:~:.:h', '%%', ''), sep)
    local file_path = ''
    for _, cur in ipairs(path_list) do
        file_path = (cur == '.' or cur == '~') and '' or
        file_path .. cur .. ' ' .. '%#LspSagaWinbarSep#>%*' .. ' %*'
    end
    return file_path .. file_name
end

local function config_winbar_or_statusline()
    local exclude = {
        ['terminal'] = true,
        ['toggleterm'] = true,
        ['prompt'] = true,
        ['NvimTree'] = true,
        ['help'] = true,
    } -- Ignore float windows and exclude filetype
    if vim.api.nvim_win_get_config(0).zindex or exclude[vim.bo.filetype] then
        vim.wo.winbar = ''
    else
        local ok, lspsaga = pcall(require, 'lspsaga.symbolwinbar')
        local sym
        if ok then sym = lspsaga.get_symbol_node() end
        local win_val = ''
        win_val = get_file_name(false) -- set to true to include path
        if sym ~= nil then win_val = win_val .. sym end
        vim.wo.winbar = win_val -- set winbar value
    end
end

local events = { 'BufEnter', 'BufWinEnter', 'CursorMoved' }
api.nvim_create_augroup('lspsaga_winbar', { clear = true })
vim.api.nvim_create_autocmd(events, {
    group = 'lspsaga_winbar',
    pattern = '*',
    callback = function() config_winbar_or_statusline() end,
})

vim.api.nvim_create_autocmd('User', {
    group = 'lspsaga_winbar',
    pattern = 'LspsagaUpdateSymbol',
    callback = function() config_winbar_or_statusline() end,
})

