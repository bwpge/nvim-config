local utils = require('user.core.utils')

local telescope = utils.require_plugin('telescope')
if not telescope then return end

local actions = utils.require_plugin('telescope.actions')
if not actions then return end

if vim.fn.executable('rg') ~= 1 then
    -- TODO: use notify for this
    vim.notify('Could not find \'rg\'. Telescope will have limited functionality!', vim.log.levels.WARN)
end

telescope.setup({
    defaults = {
        mappings = {
            i = {
                ['<esc>'] = actions.close, -- close in insert mode
                ['<C-d>'] = actions.delete_buffer, -- delete buffer from list
                -- ['<M-q>'] = actions.send_selected_to_qflist + actions.open_qflist,
            },
        }
    }
})

if require('user.core.utils').has_build_system() then
    telescope.load_extension('fzf')
end

-- TODO: check if notify plugin is available
telescope.load_extension('notify')
