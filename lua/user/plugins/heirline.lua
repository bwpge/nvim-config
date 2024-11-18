local U = require("user.utils")
local ellipsis = "…"
local indicator_label = "123456789abcdef"

local function get_tabs()
    local tabs = {}
    local curr_id = vim.fn.tabpagenr()

    for id, _ in ipairs(vim.api.nvim_list_tabpages()) do
        local active = curr_id == id
        table.insert(tabs, { id = id, active = active })
    end

    return tabs
end

local custom_icons = {
    gitrebase = { "", "DevIconGitCommit" },
    help = { "󰋖", "DevIconTxt" },
    oil = { " ", "OilDir" },
    trouble = { "󰔫", "DevIconGitConfig" },
    Trouble = { "󰔫", "DevIconGitConfig" },
}

local ff_lut = {
    unix = "LF",
    dos = "CRLF",
    mac = "CR",
}

local function is_hash(s)
    return s and #s == 40 and s:match("^[%a%d]+$") ~= nil
end

local function get_icon(s, filetype, buftype)
    local ok, icons = pcall(require, "nvim-web-devicons")
    if not ok then
        return
    end

    local item = custom_icons[s] or custom_icons[filetype or ""] or custom_icons[buftype or ""]
    if item then
        return unpack(item)
    end

    local icon, hl = icons.get_icon(s)
    -- use correct icon for treesitter query buffers
    if filetype == "query" then
        icon, hl = icons.get_icon_by_filetype(filetype)
    end
    if not icon and filetype then
        icon, hl = icons.get_icon_by_filetype(filetype)
    end
    if not icon and buftype then
        icon, hl = icons.get_icon_by_filetype(buftype)
    end

    return icon, hl
end

---@param p string
---@return string
local function get_short_dir(p)
    local parts = vim.split(p, U.path_sep, { trimempty = true }) or {}
    if #parts == 0 then
        return ""
    end
    parts[#parts] = nil

    local slice = {} ---@type string[]
    if #parts <= 2 then
        slice = parts
    else
        slice = { parts[1], ellipsis, parts[#parts] }
    end

    local s = table.concat(slice, "/")
    if #s > 0 then
        return s .. "/"
    else
        return s
    end
end

---@param left table|string
---@param right table|string
---@param fg string|function
---@param bg string|function
---@return table
local function badge(left, right, fg, bg)
    local fg_color = function(self)
        if type(fg) == "function" then
            return fg(self)
        else
            return fg
        end
    end
    local bg_color = function(self)
        if type(bg) == "function" then
            return bg(self)
        else
            return bg
        end
    end

    local l = left
    if type(left) == "string" then
        l = { provider = left }
    end
    local r = right
    if type(right) == "string" then
        r = { provider = right }
    end

    return {
        {
            provider = "",
            hl = function(self)
                local f = fg_color(self)
                local b = bg_color(self)
                return { fg = f, bg = b }
            end,
        },
        {
            hl = function(self)
                local f = fg_color(self)
                return { fg = "black", bg = f }
            end,
            l,
        },
        {
            hl = function(self)
                local f = fg_color(self)
                local b = bg_color(self)
                return { fg = f, bg = b }
            end,
            { provider = " " },
            r,
        },
        {
            provider = "",
            hl = function(self)
                local b = bg_color(self)
                return { fg = b }
            end,
        },
    }
end

local function pill(component, color)
    local s_color = function(self)
        if type(color) == "function" then
            return color(self)
        else
            return color
        end
    end

    local comp = component
    if type(comp) == "string" then
        comp = { provider = component }
    end

    return {
        {
            provider = "",
            hl = { fg = "surface_bg" },
        },
        {
            hl = function(self)
                return { fg = s_color(self), bg = "surface_bg" }
            end,
            comp,
        },
        {
            provider = "",
            hl = { fg = "surface_bg" },
        },
    }
end

---@return string
---@return string?
local function get_term_info()
    local path = vim.api.nvim_buf_get_name(0)
    local p = vim.split(path, "//")[3] or ""

    local pid = p:match("^%d+")
    if pid then
        p = p:gsub("^%d+:", "")
    end

    return p, pid
end

local mode_names = {
    ["n"] = "NORMAL",
    ["no"] = "OP-PENDING",
    ["nov"] = "OP-PENDING",
    ["noV"] = "OP-PENDING",
    ["no\22"] = "OP-PENDING",
    ["niI"] = "NORMAL",
    ["niR"] = "NORMAL",
    ["niV"] = "NORMAL",
    ["nt"] = "NORMAL",
    ["ntT"] = "NORMAL",
    ["v"] = "VISUAL",
    ["vs"] = "VISUAL",
    ["V"] = "VISUAL",
    ["Vs"] = "VISUAL",
    ["\22"] = "VISUAL",
    ["\22s"] = "VISUAL",
    ["s"] = "SELECT",
    ["S"] = "SELECT",
    ["\19"] = "SELECT",
    ["i"] = "INSERT",
    ["ic"] = "INSERT",
    ["ix"] = "INSERT",
    ["R"] = "REPLACE",
    ["Rc"] = "REPLACE",
    ["Rx"] = "REPLACE",
    ["Rv"] = "VIRT REPLACE",
    ["Rvc"] = "VIRT REPLACE",
    ["Rvx"] = "VIRT REPLACE",
    ["c"] = "COMMAND",
    ["cv"] = "VIM EX",
    ["ce"] = "EX",
    ["r"] = "PROMPT",
    ["rm"] = "MORE",
    ["r?"] = "CONFIRM",
    ["!"] = "SHELL",
    ["t"] = "TERMINAL",
}
local mode_colors = {
    NORMAL = "blue",
    INSERT = "green",
    VISUAL = "purple",
    COMMAND = "orange",
    SELECT = "purple",
    REPLACE = "cyan",
    ["OP-PENDING"] = "cyan",
    SHELL = "red",
    TERMINAL = "red",
    ["VIM EX"] = "red",
}
local function mode_color()
    local mode = mode_names[vim.api.nvim_get_mode().mode] or "NORMAL"
    return mode_colors[mode] or mode_colors["NORMAL"]
end

return {
    "rebelot/heirline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    config = function()
        local utils = require("heirline.utils")

        -- try and load lualine theme if available
        local lltheme = {}
        if vim.g.colors_name then
            local ok, t = pcall(require, "lualine.themes." .. vim.g.colors_name)
            if ok then
                lltheme = t
            end
        end

        -- extract colors from colorscheme
        local colors = {
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
            git_del = utils.get_highlight("diffRemoved").fg,
            git_add = utils.get_highlight("diffAdded").fg,
            git_change = utils.get_highlight("diffChanged").fg,
            black = utils.get_highlight("StatusLine").bg,
            inactive_fg = utils.get_highlight("StatusLineNC").fg,
            inactive_bg = utils.get_highlight("StatusLineNC").bg,
            surface_bg = lltheme.normal.b.bg,
            dim_fg = utils.get_highlight("Comment").fg,
            modified_fg = utils.get_highlight("MatchParen").fg,
            new_fg = utils.get_highlight("Special").fg,
            number_fg = utils.get_highlight("Number").fg,
        }

        local conditions = require("heirline.conditions")
        local space = { provider = " " }
        local pad = { provider = "%=" }

        local function number_pill(component)
            return {
                fallthrough = false,
                {
                    condition = conditions.is_not_active,
                    component,
                },
                pill(component, "number_fg"),
            }
        end

        ---@param icon string
        ---@param itemfn fun(): table
        ---@param isactive fun(t: table): boolean
        ---@param color string
        ---@param active_fg string
        ---@param min_show? integer
        ---@return table
        local function indicator(icon, itemfn, isactive, color, active_fg, min_show)
            min_show = min_show or 0

            return {
                condition = function(self)
                    self.items = itemfn()
                    return conditions.is_active() and #self.items >= min_show
                end,
                badge(icon, {
                    init = function(self)
                        self.total = #self.items
                        if self.total > #indicator_label then
                            self.total = #indicator_label
                        end

                        self.active_idx = -1
                        for i = 1, self.total do
                            if isactive(self.items[i]) then
                                self.active_idx = i
                            end
                        end
                    end,
                    {
                        provider = function(self)
                            if self.active_idx > 0 then
                                return indicator_label:sub(1, self.active_idx - 1)
                            end
                            return indicator_label:sub(1, self.total)
                        end,
                    },
                    {
                        hl = active_fg,
                        provider = function(self)
                            if self.active_idx > 0 then
                                return indicator_label:sub(self.active_idx, self.active_idx)
                            end
                        end,
                    },
                    {
                        provider = function(self)
                            if self.active_idx > 0 then
                                return indicator_label:sub(self.active_idx + 1, self.total)
                            end
                        end,
                    },
                }, color, "surface_bg"),
                space,
            }
        end

        local vimode = {
            provider = function()
                return mode_names[vim.api.nvim_get_mode().mode] or "UNKNOWN"
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
        }
        vimode = { utils.surround({ "", "" }, mode_color, vimode), space }

        local ficon = {
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
            space,
        }
        local fdir = {
            condition = function()
                return not conditions.buffer_matches({
                    filetype = { "help", "fugitiveblame" },
                })
            end,
            provider = function(self)
                return self.dir
            end,
        }
        local function fname_hl(self)
            if vim.bo.modified then
                return { fg = "modified_fg", bold = true }
            elseif self.is_new then
                return { fg = "new_fg", bold = true }
            end
        end

        local pretty_path = {
            init = function(self)
                self.path = vim.fn.expand("%:~:."):gsub("^(%a[%a%d%-%+%.]*)://", "")
                self.name = vim.fn.expand("%:t")
                self.is_readonly = vim.bo.modifiable == false or vim.bo.readonly == true
                self.is_unnamed = self.path == ""
                self.is_new = not self.is_readonly
                    and not self.is_unnamed
                    and vim.bo.buftype == ""
                    and not vim.wo.diff
                    ---@diagnostic disable-next-line: undefined-field
                    and vim.uv.fs_stat(vim.fn.expand("%:p")) == nil
                self.icon, self.icon_hl = get_icon(self.path, vim.bo.ft, vim.bo.bt)
                self.has_icon = type(self.icon) == "string" and #self.icon > 0

                if not self.is_new then
                    self.dir = get_short_dir(self.path)
                else
                    self.dir = ""
                end
            end,
            ficon,
            fdir,
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

        local git_info = {
            condition = conditions.is_git_repo,
            badge(" ", {
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
            }, "dim_fg", "surface_bg"),
            space,
        }

        local grapplelist = indicator(" ", function()
            return require("grapple").tags() or {}
        end, function(tag)
            return tag.path == vim.fn.expand("%:p")
        end, "cyan", "Number")

        local diagnostics = {
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
            space,
            {
                condition = function(self)
                    return self.errors > 0
                end,
                hl = { fg = "diag_error" },
                provider = function(self)
                    return self.error_icon .. self.errors
                end,
                space,
            },
            {
                condition = function(self)
                    return self.warnings > 0
                end,
                hl = { fg = "diag_warn" },
                provider = function(self)
                    return self.warn_icon .. self.warnings
                end,
                space,
            },
            {
                condition = function(self)
                    return self.info > 0
                end,
                hl = { fg = "diag_info" },
                provider = function(self)
                    return self.info_icon .. self.info
                end,
                space,
            },
            {
                condition = function(self)
                    return self.hints > 0
                end,
                hl = { fg = "diag_hint" },
                provider = function(self)
                    return self.hint_icon .. self.hints
                end,
                space,
            },
        }

        local file_info = {
            condition = function()
                return vim.bo.modifiable
            end,
            init = function(self)
                self.ff = ff_lut[vim.bo.ff] or ""
                self.fenc = string.upper(vim.bo.fenc or "")
            end,
            hl = function(self)
                if self.ff ~= "LF" then
                    return { fg = "red" }
                end
                return { fg = "dim_fg" }
            end,
            provider = function(self)
                return self.ff
            end,
            {
                condition = function(self)
                    return self.fenc ~= ""
                end,
                hl = { fg = "dim_fg" },
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
                    return { fg = "dim_fg" }
                end,
                provider = function(self)
                    return self.fenc
                end,
            },
            space,
        }

        local attached_lsps = {
            condition = function()
                return #vim.lsp.get_clients({ bufnr = 0 }) > 0
            end,
            badge(" ", {
                init = function(self)
                    self.clients = vim.tbl_map(function(c)
                        return c.name
                    end, vim.lsp.get_clients({ bufnr = 0 }))
                end,
                provider = function(self)
                    return table.concat(self.clients, ", ")
                end,
                space,
            }, "green", "surface_bg"),
        }

        local location = badge(" ", {
            provider = function()
                local r, c = unpack(vim.api.nvim_win_get_cursor(0))
                return r .. ":" .. (c + 1)
            end,
            update = { "CursorMoved", "CursorMovedI" },
        }, "yellow", "surface_bg")

        local fugitive_path = {
            condition = function()
                return vim.bo.ft:match("^fugitive") ~= nil
                    or vim.fn.bufname():match("^fugitive:") ~= nil
            end,
            init = function(self)
                local p = vim.fn.expand("%:~:.")
                local path = vim.split(p, U.path_sep .. U.path_sep)[3] or p

                local id = path:match("^(%d+)" .. U.path_sep)
                if id then
                    self.fid = id
                    path = path:gsub("^%d+" .. U.path_sep, "")
                end

                self.dir = get_short_dir(path)
                self.name = vim.fn.fnamemodify(path, ":t")
                self.icon, self.icon_hl = get_icon(vim.wo.diff and "diff" or "git")
                self.has_icon = type(self.icon) == "string" and #self.icon > 0
            end,
            ficon,
            fdir,
            -- name
            {
                hl = function(self)
                    if is_hash(self.name) then
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
                space,
                number_pill({
                    provider = function(self)
                        return self.fid
                    end,
                }),
            },
        }

        local toggleterm_sl = {
            static = {
                suffix = vim.fn.has("win32") == 1 and "::toggleterm::" or "#toggleterm#",
            },
            init = function(self)
                local p, pid = get_term_info()
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
            { condition = conditions.is_active, vimode },
            { condition = conditions.is_active, hl = { fg = "green" }, provider = " " },
            {
                provider = function(self)
                    return self.name
                end,
            },
            space,
            number_pill({
                provider = function(self)
                    return self.tid
                end,
            }),
            space,
            {
                hl = "Comment",
                provider = function(self)
                    return self.pid
                end,
            },
            pad,
        }

        local term_sl = {
            init = function(self)
                local p, pid = get_term_info()
                if pid then
                    self.pid = pid
                end
                self.name = vim.fn.fnamemodify(p, ":t")
            end,
            condition = function()
                return vim.bo.buftype == "terminal"
            end,
            { condition = conditions.is_active, vimode },
            { condition = conditions.is_active, hl = { fg = "green" }, provider = " " },
            {
                provider = function(self)
                    return self.name
                end,
            },
            space,
            {
                hl = "Comment",
                provider = function(self)
                    return self.pid
                end,
            },
            pad,
        }

        local path_info = {
            fallthrough = false,
            fugitive_path,
            pretty_path,
        }

        local default_sl = {
            vimode,
            git_info,
            path_info,
            pad,
            diagnostics,
            file_info,
            grapplelist,
            attached_lsps,
            location,
            space,
        }

        local empty_sl = {
            condition = function()
                return conditions.buffer_matches({
                    filetype = { "neo%-tree", "trouble", "Trouble" },
                })
            end,
            pad,
        }

        local inactive_sl = {
            condition = conditions.is_not_active,
            path_info,
            pad,
        }

        local statuslines = {
            hl = function()
                if conditions.is_active() then
                    return "StatusLine"
                else
                    return {
                        fg = "inactive_fg",
                        bg = "inactive_bg",
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

        local tablist = indicator("󰓩 ", get_tabs, function(tab)
            return tab.active == true
        end, "blue", "Number", 2)

        local tabcwd = {
            provider = function()
                return vim.fn.fnamemodify(vim.fn.getcwd(-1), ":~:."):gsub("\\", "/")
            end,
        }

        local tabline = {
            pad,
            tablist,
            tabcwd,
            pad,
        }

        require("heirline").setup({
            opts = {
                colors = colors,
            },
            ---@diagnostic disable-next-line: missing-fields
            statusline = statuslines,
            tabline = tabline,
        })
    end,
}
