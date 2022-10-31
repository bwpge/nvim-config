local notify = require('user.core.utils').require_plugin('notify', { notify = false })
if not notify then return end

vim.notify = notify
