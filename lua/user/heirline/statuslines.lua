local C = require("user.heirline.components")
local styles = require("user.heirline.styles")
local helpers = require("user.heirline.helpers")
local conditions = require("heirline.conditions")

local toggleterm_sl = {
    static = {
        suffix = vim.fn.has("win32") == 1 and "::toggleterm::" or "#toggleterm#",
    },
    init = function(self)
        local p, pid = helpers.get_term_info()
        if pid then
            self.pid = pid
        end

        local tid = p:match(self.suffix .. "(%d+)$")
        if tid then
            self.tid = tid
            p = p:gsub("[&;]?" .. self.suffix .. "%d+$", "")
        end
        self.name = p

        if package.loaded.toggleterm then
            if self.tid then
                local term = require("toggleterm.terminal").get(tonumber(self.tid))
                if term then
                    self.name = term:_display_name()
                end
            end
        end
    end,
    condition = function()
        return vim.bo.filetype == "toggleterm"
    end,
    { condition = conditions.is_active, C.vimode },
    { condition = conditions.is_active, hl = { fg = "green" }, provider = " " },
    {
        provider = function(self)
            return self.name
        end,
    },
    C.space,
    styles.number_pill({
        provider = function(self)
            return self.tid
        end,
    }),
    C.space,
    {
        hl = "Comment",
        provider = function(self)
            return self.pid
        end,
    },
    C.pad,
}

local term_sl = {
    init = function(self)
        local p, pid = helpers.get_term_info()
        if pid then
            self.pid = pid
        end
        self.name = vim.fn.fnamemodify(p, ":t")
    end,
    condition = function()
        return vim.bo.buftype == "terminal"
    end,
    C.active_vimode,
    {
        condition = conditions.is_active,
        hl = { fg = "green" },
        provider = " ",
    },
    {
        provider = function(self)
            return self.name
        end,
    },
    C.space,
    {
        hl = "Comment",
        provider = function(self)
            return self.pid
        end,
    },
    C.pad,
}

local default_sl = {
    C.vimode,
    C.git_info,
    C.path_info,
    C.pad,
    C.diagnostics,
    C.file_info,
    C.python_env,
    C.grapple,
    C.attached_lsps,
    C.location,
}

local empty_sl = {
    condition = function()
        return conditions.buffer_matches({
            filetype = { "neo%-tree", "trouble", "Trouble" },
        })
    end,
    C.pad,
}

local inactive_sl = {
    condition = conditions.is_not_active,
    C.path_info,
    C.pad,
}

return {
    hl = function()
        if conditions.is_active() then
            return "StatusLine"
        else
            return {
                fg = "fg_inactive",
                bg = "bg_inactive",
                bold = false,
                italic = false,
                force = true,
            }
        end
    end,
    fallthrough = false,
    empty_sl,
    toggleterm_sl,
    term_sl,
    inactive_sl,
    default_sl,
}
