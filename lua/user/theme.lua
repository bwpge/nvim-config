local utils = require("user.utils")

local M = {}

local c = utils.prequire("user.customize")
if c and c.theme then
    M.name = c.theme
else
    M.name = "catppuccin"
end

---Checks if the given theme is active (matches `M.name`) and runs the setup
---function.
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

    -- misc fixes for themes
    if name == "dracula" then
        vim.g.terminal_color_0 = "#6272A4"
        vim.g.terminal_color_8 = "#6272A4"
    end
end

---Returns a function to be used in lazy.nvim plugin spec config for themes.
---@param name string The name of the theme module and colorscheme
---@return function
function M.make_config(name)
    return function(_, opts)
        M.run_setup(name, opts)
    end
end

return M
