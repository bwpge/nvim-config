local fidget = require('user.core.utils').require_plugin('fidget')
if not fidget then return end

-- color formatting
-- may need to adjust this per theme, onedark defaults don't look very good
vim.api.nvim_set_hl(0, 'FidgetTitle', { link = 'Function' })
vim.api.nvim_set_hl(0, 'FidgetTask', { link = 'ModeMsg' })

fidget.setup({
    text = {
        spinner = 'dots',
        done = '',
        completed = 'Done',
    },
    timer = {
        spinner_rate = 125, -- default 125
        fidget_decay = 1000, -- relative to tasks completing
        task_decay = 1000, -- absolute from completion time
    },
    window = {
        blend = 65,
    },
})

