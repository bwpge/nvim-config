local utils = require("user.utils")

local M = {}

-- use this field to change colorscheme for editor and plugins
M.name = "dracula"

---Checks if the given theme is active and runs the setup if required.
---@param name string The name of the theme module and colorscheme
---@param opts table? Options to be passed to the theme module setup function
function M.run_setup(name, opts)
    local mod = utils.prequire(name)
    if not mod then
        vim.notify(string.format("Failed to load theme module `%s`", name), vim.log.levels.ERROR)
        return
    end
    if M.name == name then
        mod.setup(opts or {})
        vim.cmd("colorscheme " .. name)
    end
end

return M
