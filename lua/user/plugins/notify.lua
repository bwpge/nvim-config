local notify = require('user.core.utils').require_plugin('notify', { notify = false })
if not notify then return end

vim.notify = notify

-- custom highlights for vim-notify
local theme_name = require('user.core.theme').theme_name

if theme_name == 'onedark' then
    local c = {
        red = '#e06c75',
        yellow = '#e5c07b',
        blue = '#61afef',
        cyan = '#56b6c2',
        grey = '#5c6370',
    }
    local hl_notify = {
        NotifyERRORBorder = c.red,
        NotifyWARNBorder = c.yellow,
        NotifyINFOBorder = c.blue,
        NotifyDEBUGBorder = c.cyan,
        NotifyTRACEBorder = c.grey,
        NotifyERRORIcon = c.red,
        NotifyWARNIcon = c.yellow,
        NotifyINFOIcon = c.blue,
        NotifyDEBUGIcon = c.cyan,
        NotifyTRACEIcon = c.grey,
        NotifyERRORTitle = c.red,
        NotifyWARNTitle = c.yellow,
        NotifyINFOTitle = c.blue,
        NotifyDEBUGTitle = c.cyan,
        NotifyTRACETitle = c.grey,
    }

    -- TODO: darken border colors, blend doesn't seem to work
    for group, color in pairs(hl_notify) do
        vim.api.nvim_set_hl(0, group, { fg = color })
    end
end
