local U = require("user.utils")
local helpers = require("user.heirline.helpers")
local styles = require("user.heirline.styles")
local mode = require("user.heirline.mode")
local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

local M = {}

local function fname_hl(self)
    if vim.bo.modified then
        return { fg = "fg_modified", bold = true }
    elseif self.is_new then
        return { fg = "fg_new", bold = true }
    end
end

M.space = { provider = " " }

M.pad = { provider = "%=" }

M.vimode = {
    utils.surround({ "", "" }, mode.get_color, {
        provider = function()
            return mode.names[vim.api.nvim_get_mode().mode] or "UNKNOWN"
        end,
        condition = conditions.is_active,
        hl = { fg = "black", bold = true },
        update = {
            "ModeChanged",
            pattern = "*",
            callback = vim.schedule_wrap(function()
                vim.cmd.redrawstatus()
            end),
        },
    }),
    M.space,
}

M.active_vimode = {
    condition = conditions.is_active(),
    M.vimode,
}

M.git_info = {
    condition = conditions.is_git_repo,
    styles.badge({
        left = " ",
        right = {
            init = function(self)
                self.status = vim.b.gitsigns_status_dict
                self.has_changes = self.status.added ~= 0
                    or self.status.changed ~= 0
                    or self.status.removed ~= 0
                self.head = self.status.head
            end,
            provider = function(self)
                return self.head
            end,
        },
        primary = "fg_dim",
        secondary = "bg_surface",
    }),
}

local python_env_name = helpers.get_python_env_name()

M.python_env = {
    static = {
        env_name = helpers.get_python_env_name(),
    },
    condition = function()
        return python_env_name ~= nil
    end,
    styles.badge({
        left = " ",
        right = function(self)
            return self.env_name
        end,
        primary = "yellow",
        secondary = "bg_surface",
    }),
}

M.file_icon = {
    condition = function(self)
        return conditions.is_active() and self.has_icon and not self.is_new
    end,
    {
        hl = function(self)
            return self.icon_hl
        end,
        provider = function(self)
            return self.icon
        end,
    },
    M.space,
}

M.directory = {
    condition = function()
        return not conditions.buffer_matches({
            filetype = { "help", "fugitiveblame" },
        })
    end,
    provider = function(self)
        return self.dir
    end,
}

M.pretty_path = {
    init = function(self)
        self.path = vim.fn.expand("%:~:."):gsub("^(%a[%a%d%-%+%.]*)://", "")
        self.name = vim.fn.expand("%:t")
        self.is_readonly = vim.bo.modifiable == false or vim.bo.readonly == true
        self.is_unnamed = self.path == ""
        self.is_new = not self.is_readonly
            and not self.is_unnamed
            and vim.bo.buftype == ""
            and not vim.wo.diff
            and vim.uv.fs_stat(vim.fn.expand("%:p")) == nil
        self.icon, self.icon_hl = helpers.get_icon(self.path, vim.bo.ft, vim.bo.bt)
        self.has_icon = type(self.icon) == "string" and #self.icon > 0

        if not self.is_new then
            self.dir = helpers.shorten_dir(self.path)
        else
            self.dir = ""
        end
    end,
    M.file_icon,
    M.directory,
    {
        hl = fname_hl,
        provider = function(self)
            if self.is_unnamed then
                return "[No Name]"
            else
                return self.name
            end
        end,
    },
    {
        condition = function(self)
            return self.is_readonly
        end,
        provider = " ",
    },
}

M.fugitive_path = {
    condition = function()
        return vim.bo.ft:match("^fugitive") ~= nil or vim.fn.bufname():match("^fugitive:") ~= nil
    end,
    init = function(self)
        local p = vim.fn.expand("%:~:.")
        local path = vim.split(p, U.path_sep .. U.path_sep)[3] or p

        local id = path:match("^(%d+)" .. U.path_sep)
        if id then
            self.fid = id
            path = path:gsub("^%d+" .. U.path_sep, "")
        end

        self.dir = helpers.shorten_dir(path)
        self.name = vim.fn.fnamemodify(path, ":t")
        self.icon, self.icon_hl = helpers.get_icon(vim.wo.diff and "diff" or "git")
        self.has_icon = type(self.icon) == "string" and #self.icon > 0
    end,
    M.file_icon,
    M.directory,
    -- name
    {
        hl = function(self)
            if helpers.is_hash(self.name) then
                return "fugitiveHash"
            end
            return fname_hl(self)
        end,
        provider = function(self)
            if self.name == "" then
                return "Git status"
            elseif vim.bo.filetype == "fugitiveblame" then
                return "Git blame"
            else
                return self.name
            end
        end,
    },
    -- id
    {
        condition = function(self)
            return self.fid ~= nil and self.name ~= ""
        end,
        M.space,
        styles.number_pill({
            provider = function(self)
                return self.fid
            end,
        }),
    },
}

M.path_info = {
    fallthrough = false,
    M.fugitive_path,
    M.pretty_path,
}

M.grapple = styles.indicator({
    icon = " ",
    items_fn = function()
        return require("grapple").tags() or {}
    end,
    is_active = function(tag)
        return tag.path == vim.fn.expand("%:p")
    end,
    color = "cyan",
})

M.diagnostics = {
    condition = conditions.has_diagnostics,
    static = {
        error_icon = " ",
        warn_icon = " ",
        info_icon = "󰋼 ",
        hint_icon = "󰌵 ",
    },
    init = function(self)
        self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
        self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
        self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
        self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
    end,
    update = { "DiagnosticChanged", "BufEnter" },
    M.space,
    {
        condition = function(self)
            return self.errors > 0
        end,
        hl = { fg = "diag_error" },
        provider = function(self)
            return self.error_icon .. self.errors
        end,
        M.space,
    },
    {
        condition = function(self)
            return self.warnings > 0
        end,
        hl = { fg = "diag_warn" },
        provider = function(self)
            return self.warn_icon .. self.warnings
        end,
        M.space,
    },
    {
        condition = function(self)
            return self.info > 0
        end,
        hl = { fg = "diag_info" },
        provider = function(self)
            return self.info_icon .. self.info
        end,
        M.space,
    },
    {
        condition = function(self)
            return self.hints > 0
        end,
        hl = { fg = "diag_hint" },
        provider = function(self)
            return self.hint_icon .. self.hints
        end,
        M.space,
    },
}

M.file_info = {
    static = {
        ff_map = {
            unix = "LF",
            dos = "CRLF",
            mac = "CR",
        },
    },
    condition = function()
        return vim.bo.modifiable
    end,
    init = function(self)
        self.ff = self.ff_map[vim.bo.ff] or ""
        self.fenc = string.upper(vim.bo.fenc or "")
    end,
    hl = function(self)
        if self.ff ~= "LF" then
            return { fg = "red" }
        end
        return { fg = "fg_dim" }
    end,
    provider = function(self)
        return self.ff
    end,
    {
        condition = function(self)
            return self.fenc ~= ""
        end,
        hl = { fg = "fg_dim" },
        provider = ":",
    },
    {
        condition = function(self)
            return self.fenc ~= ""
        end,
        hl = function(self)
            if self.fenc ~= "UTF-8" then
                return { fg = "red" }
            end
            return { fg = "fg_dim" }
        end,
        provider = function(self)
            return self.fenc
        end,
    },
    M.space,
}

M.attached_lsps = {
    condition = function()
        return #vim.lsp.get_clients({ bufnr = 0 }) > 0
    end,
    styles.badge({
        left = " ",
        right = {
            init = function(self)
                self.clients = vim.tbl_map(function(c)
                    return c.name
                end, vim.lsp.get_clients({ bufnr = 0 }))
            end,
            provider = function(self)
                return table.concat(self.clients, ", ")
            end,
        },
        primary = "green",
        secondary = "bg_surface",
    }),
}

M.location = styles.badge({
    left = " ",
    right = {
        provider = function()
            local r, c = unpack(vim.api.nvim_win_get_cursor(0))
            return r .. ":" .. (c + 1)
        end,
        update = { "CursorMoved", "CursorMovedI" },
    },
    primary = "white",
    secondary = "bg_surface",
})

return M
