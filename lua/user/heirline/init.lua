local utils = require("heirline.utils")

local M = {}

---@alias Component table
---@alias ComponentLike Component|string
---@alias ComponentColor string|fun(self):string
---@alias ComponentHighlight string|table|fun(self):table|string|nil

function M.colors()
    -- try and load lualine theme if available
    local theme = {}
    if vim.g.colors_name then
        local ok, t = pcall(require, "lualine.themes." .. vim.g.colors_name)
        if ok then
            theme = t
        end
    end

    local bg_surface
    if theme.normal then
        bg_surface = theme.normal.b.bg
    end
    if not bg_surface then
        bg_surface = utils.get_highlight("TelescopePromptBorder").bg
    end

    return {
        red = utils.get_highlight("Error").fg,
        green = utils.get_highlight("String").fg,
        blue = utils.get_highlight("Function").fg,
        gray = utils.get_highlight("NonText").fg,
        orange = utils.get_highlight("Constant").fg,
        purple = utils.get_highlight("Keyword").fg,
        yellow = utils.get_highlight("Type").fg,
        cyan = utils.get_highlight("Operator").fg,
        diag_warn = utils.get_highlight("DiagnosticWarn").fg,
        diag_error = utils.get_highlight("DiagnosticError").fg,
        diag_hint = utils.get_highlight("DiagnosticHint").fg,
        diag_info = utils.get_highlight("DiagnosticInfo").fg,
        black = utils.get_highlight("StatusLine").bg,
        fg_inactive = utils.get_highlight("StatusLineNC").fg,
        bg_inactive = utils.get_highlight("StatusLineNC").bg,
        bg_surface = bg_surface,
        fg_dim = utils.get_highlight("Comment").fg,
        fg_modified = utils.get_highlight("MatchParen").fg,
        fg_new = utils.get_highlight("Special").fg,
        fg_number = utils.get_highlight("Number").fg,
    }
end

M.statuslines = require("user.heirline.statuslines")

M.tablines = require("user.heirline.tablines")

return M
