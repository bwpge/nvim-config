local conditions = require("heirline.conditions")

local M = {}

---@class BadgeOptions
---@field left ComponentLike
---@field right ComponentLike
---@field primary ComponentColor
---@field secondary ComponentColor

---@param opts BadgeOptions
---@return Component
function M.badge(opts)
    local fg_color = function(self)
        if type(opts.primary) == "function" then
            return opts.primary(self)
        else
            return opts.primary
        end
    end
    local bg_color = function(self)
        if type(opts.secondary) == "function" then
            return opts.secondary(self)
        else
            return opts.secondary
        end
    end

    local left = opts.left
    if type(opts.left) == "string" or type(opts.right) == "function" then
        left = { provider = opts.left }
    end
    local right = opts.right
    if type(opts.right) == "string" or type(opts.right) == "function" then
        right = { provider = opts.right }
    end

    return {
        {
            provider = "",
            hl = function(self)
                local fg = fg_color(self)
                local bg = bg_color(self)
                return { fg = fg, bg = bg }
            end,
        },
        {
            hl = function(self)
                local fg = fg_color(self)
                return { fg = "black", bg = fg }
            end,
            left,
        },
        {
            hl = function(self)
                local fg = fg_color(self)
                local bg = bg_color(self)
                return { fg = fg, bg = bg }
            end,
            { provider = " " },
            right,
        },
        {
            provider = "",
            hl = function(self)
                local bg = bg_color(self)
                return { fg = bg }
            end,
        },
        { provider = " " },
    }
end

---@param component ComponentLike
---@param color ComponentColor
---@return Component
function M.pill(component, color)
    local s_color = function(self)
        if type(color) == "function" then
            return color(self)
        else
            return color
        end
    end

    local comp = component
    if type(comp) == "string" or type(comp) == "function" then
        comp = { provider = component }
    end

    return {
        {
            provider = "",
            hl = { fg = "bg_surface" },
        },
        {
            hl = function(self)
                return { fg = s_color(self), bg = "bg_surface" }
            end,
            comp,
        },
        {
            provider = "",
            hl = { fg = "bg_surface" },
        },
    }
end

---@class IndicatorOptions
---@field icon? string
---@field labels? string
---@field items_fn? fun(): table[]
---@field is_active? fun(item: table): boolean
---@field color? ComponentColor
---@field active_hl? ComponentHighlight
---@field min_show? integer

---@type IndicatorOptions
local default_indicator_opts = {
    icon = "",
    labels = "123456789abcdef",
    items_fn = function()
        return {}
    end,
    is_active = function()
        return false
    end,
    color = "red",
    active_hl = "Number",
    min_show = 1,
}

---@param opts IndicatorOptions
---@return Component
function M.indicator(opts)
    ---@type IndicatorOptions
    opts = vim.tbl_extend("force", default_indicator_opts, opts or {})
    local right = {
        init = function(self)
            self.total = #self.items
            if self.total > #opts.labels then
                self.total = #opts.labels
            end

            self.active_idx = -1
            for i = 1, self.total do
                if opts.is_active(self.items[i]) then
                    self.active_idx = i
                end
            end
        end,
        {
            provider = function(self)
                if self.active_idx > 0 then
                    return opts.labels:sub(1, self.active_idx - 1)
                end
                return opts.labels:sub(1, self.total)
            end,
        },
        {
            hl = opts.active_hl,
            provider = function(self)
                if self.active_idx > 0 then
                    return opts.labels:sub(self.active_idx, self.active_idx)
                end
            end,
        },
        {
            provider = function(self)
                if self.active_idx > 0 then
                    return opts.labels:sub(self.active_idx + 1, self.total)
                end
            end,
        },
    }

    return {
        static = {
            itemfn = opts.items_fn,
        },
        condition = function(self)
            self.items = self.itemfn()
            return conditions.is_active() and #self.items >= opts.min_show
        end,
        M.badge({
            left = opts.icon,
            right = right,
            primary = opts.color,
            secondary = "bg_surface",
        }),
        M.space,
    }
end

---@param component Component
---@return Component
function M.number_pill(component)
    return {
        fallthrough = false,
        {
            condition = conditions.is_not_active,
            component,
        },
        M.pill(component, "fg_number"),
    }
end

return M
