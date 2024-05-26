local C = require("user.customize")
local U = require("user.utils")

local M = {}

if C.theme then
    M.name = C.theme
else
    M.name = "catppuccin"
end

---Checks if the given theme is active (matches `M.name`) and runs the setup
---function.
---@param name string The name of the theme module and colorscheme
---@param opts table? Options to be passed to the theme module setup function
function M.run_setup(name, opts)
    local mod = U.prequire(name)
    if not mod then
        U.notify_error("Failed to load theme module `%s`", name)
        return
    end

    -- merge customize module options
    opts = vim.tbl_deep_extend("force", opts or {}, C[name] or {})
    mod.setup(opts)

    if M.name == name then
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
