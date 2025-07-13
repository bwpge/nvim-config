local M = {}

M.is_windows = vim.fn.has("win32") == 1 or jit.os == "Windows"

M.path_sep = package.config:sub(1, 1)

---Shorthand for `vim.notify` errors with a formatted message.
---@param fmt string
---@param ... any
function M.err(fmt, ...)
    vim.notify(string.format(fmt, ...), vim.log.levels.ERROR)
end

---Shorthand for `vim.notify` warnings with a formatted message.
---@param fmt string
---@param ... any
function M.warn(fmt, ...)
    vim.notify(string.format(fmt, ...), vim.log.levels.WARN)
end

---Shorthand for `vim.notify` info with a formatted message.
---@param fmt string
---@param ... any
function M.info(fmt, ...)
    vim.notify(string.format(fmt, ...), vim.log.levels.INFO)
end

---Returns the module if it could be loaded, otherwise nil.
---@param mod string
---@return table?
function M.prequire(mod)
    local ok, m = pcall(require, mod)
    if not ok then
        return nil
    end
    return m
end

M.dot_func = nil

---Makes a keymap repeatable with `.`. The mapping must use `expr = true`.
---@param f string|function Strings are wrapped as function calls to `vim.cmd`
---@return function
function M.make_repeatable(f)
    local fn = f
    if type(f) == "string" then
        fn = function()
            vim.cmd(f)
        end
    end

    return function()
        M.dot_func = fn
        vim.go.operatorfunc = "v:lua.require'config.utils'.dot_func"
        return "g@l"
    end
end

---Creates a keymap with sensible defaults.
---@param modes string|table
---@param lhs string
---@param rhs string|function
---@param desc string?
---@param opts table?
function M.kmap(modes, lhs, rhs, desc, opts)
    opts = opts or {}
    if desc then
        opts.desc = desc
    end

    vim.keymap.set(modes, lhs, rhs, opts)
end

---Creates a repeatable keymap with sensible defaults.
---@param mode string|table
---@param lhs string
---@param rhs string|function
---@param desc string?
---@param opts table?
function M.repeat_kmap(mode, lhs, rhs, desc, opts)
    opts = opts or {}
    opts.expr = true
    M.kmap(mode, lhs, M.make_repeatable(rhs), desc, opts)
end

---Creates a normal mode keymap with sensible defaults.
---@param lhs string
---@param rhs string|function
---@param desc string?
---@param opts table?
function M.nmap(lhs, rhs, desc, opts)
    M.kmap("n", lhs, rhs, desc, opts)
end

---Creates a repeatable normal mode keymap with sensible defaults.
---@param lhs string
---@param rhs string|function
---@param desc string?
---@param opts table?
function M.repeat_nmap(lhs, rhs, desc, opts)
    opts = opts or {}
    opts.expr = true
    M.nmap(lhs, M.make_repeatable(rhs), desc, opts)
end

---Creates an insert mode keymap with sensible defaults.
---@param lhs string
---@param rhs string|function
---@param desc string?
---@param opts table?
function M.imap(lhs, rhs, desc, opts)
    M.kmap("i", lhs, rhs, desc, opts)
end

---Creates a visual mode keymap with sensible defaults.
---@param lhs string
---@param rhs string|function
---@param desc string?
---@param opts table?
function M.vmap(lhs, rhs, desc, opts)
    M.kmap("x", lhs, rhs, desc, opts)
end

---Creates a lazy.nvim keymap with sensible defaults.
---@param modes string|table
---@param lhs string
---@param rhs string|function
---@param desc string?
---@param opts table?
---@return table
function M.lazy_kmap(modes, lhs, rhs, desc, opts)
    opts = opts or {}
    if desc then
        opts.desc = desc
    end
    local result = {
        lhs,
        rhs,
        mode = modes,
        noremap = true,
        silent = true,
    }

    for k, v in pairs(opts) do
        result[k] = v
    end
    return result
end

---Creates a normal mode lazy.nvim keymap with sensible defaults.
---@param lhs string
---@param rhs string|function
---@param desc string?
---@param opts table?
---@return table
function M.lazy_nmap(lhs, rhs, desc, opts)
    return M.lazy_kmap("n", lhs, rhs, desc, opts)
end

---Set keymaps for a table exported from `config.keymaps`
---@param key string Key of exported table
---@param opts table? Common options to set for all keymaps
function M.set_config_keymap(key, opts)
    local keys = require("config.keymaps")[key]
    if not keys then
        M.err("Cannot set keymaps for invalid key '%s'", key)
        return
    end

    opts = opts or {}
    for _, v in ipairs(keys) do
        local t = {}
        t = vim.tbl_extend("force", opts, v.opts or {})
        if v[3] then
            t.desc = v[3]
        end

        local mode = v.mode or "n"
        if v.dot then
            M.repeat_kmap(mode, v[1], v[2], nil, t)
        else
            vim.keymap.set(mode, v[1], v[2], t)
        end
    end
end

function M.make_winhl(t)
    local s = {}
    for k, v in pairs(t) do
        table.insert(s, k .. ":" .. v)
    end
    return table.concat(s, ",")
end

---Spawns the given process with the buffer name as the last argument.
---@param prog string
---@param buf number? Buffer number (default: 0)
---@param args table? Arguments list to use
function M.spawn_with_buf(prog, buf, args)
    local p = vim.fn.exepath(prog)
    if not p then
        return
    end
    args = args or {}

    buf = buf or 0
    local bo = vim.bo[buf]
    if not bo.buflisted or bo.filetype == "help" then
        return
    end
    local name = vim.api.nvim_buf_get_name(buf) or ""

    if #vim.fn.glob(name) < 1 then
        M.notify_info("Current buffer does not exist on disk")
        return
    end
    table.insert(args, name)

    -- use relative name if we can
    local rel_name = name
    local Path = M.prequire("plenary.path")
    if Path then
        rel_name = Path:new(name):make_relative()
    end

    local handle, _ = vim.uv.spawn(p, {
        detached = true,
        args = args,
    })
    if handle then
        vim.uv.unref(handle)
    end
    M.notify_info("Opening '%s' with '%s'", rel_name, prog)
end

---Recursively searches the input table for `old` and replaces it with `new`.
---@param t table
---@param old any
---@param new any
function M.deep_replace(t, old, new)
    if not t then
        return
    end

    for k, v in pairs(t) do
        if type(v) == "table" then
            M.deep_replace(v, old, new)
        elseif v == old then
            t[k] = new
        end
    end
end

---Formats a lualine component with a highlight group.
---@param component any
---@param text string
---@param hl_group? string
---@return string
function M.lualine_format_hl(component, text, hl_group)
    if not hl_group or hl_group == "" or text == "" then
        return text
    end

    ---@type table<string, string>
    component.hl_cache = component.hl_cache or {}
    local lualine_hl_group = component.hl_cache[hl_group]
    if not lualine_hl_group then
        local lu = require("lualine.utils.utils")
        ---@type string[]
        local gui = vim.tbl_filter(function(x)
            return x
        end, {
            lu.extract_highlight_colors(hl_group, "bold") and "bold",
            lu.extract_highlight_colors(hl_group, "italic") and "italic",
        })

        lualine_hl_group = component:create_hl({
            fg = lu.extract_highlight_colors(hl_group, "fg"),
            gui = #gui > 0 and table.concat(gui, ",") or nil,
        }, "USER_" .. hl_group) --[[@as string]]
        component.hl_cache[hl_group] = lualine_hl_group
    end

    return component:format_hl(lualine_hl_group) .. text .. component:get_default_hl()
end

function M.create_window(bufnr, opts)
    local width = math.floor(vim.o.columns * 0.87)
    local height = math.floor(vim.o.lines * 0.75)

    opts = vim.tbl_deep_extend("keep", opts or {}, {
        relative = "editor",
        row = math.floor(((vim.o.lines - height) / 2) - 1),
        col = math.floor((vim.o.columns - width) / 2),
        width = width,
        height = height,
        border = "single",
    })

    local win_id = vim.api.nvim_open_win(bufnr, true, opts)
    if win_id == 0 then
        M.notify_error("Failed to create window")
    end

    local function close()
        if bufnr ~= nil and vim.api.nvim_buf_is_valid(bufnr) then
            vim.api.nvim_buf_delete(bufnr, { force = true })
        end
        if win_id ~= nil and vim.api.nvim_win_is_valid(win_id) then
            vim.api.nvim_win_close(win_id, true)
        end
    end

    vim.keymap.set("n", "<Esc>", close, { buffer = bufnr })
    vim.keymap.set("n", "q", close, { buffer = bufnr })

    return win_id
end

---Prompts the user and executes `action` if confirmed.
---@param prompt string
---@param action function
function M.confirm_yn(prompt, action)
    vim.ui.input({ prompt = prompt .. " (y/n)" }, function(input)
        if not input then
            return
        end
        ---@cast input string
        local answer = input:lower():sub(1, 1)
        if answer ~= "y" then
            return
        end
        action()
    end)
end

---Returns whether or not any element in the table is `true`.
---@param tbl any
---@return boolean
function M.any(tbl)
    for _, v in ipairs(tbl) do
        if v == true then
            return true
        end
    end
    return false
end

---Returns whether or not all elements in the table are `true`.
---@param tbl any
---@return boolean
function M.all(tbl)
    for _, v in ipairs(tbl) do
        if v ~= true then
            return false
        end
    end
    return true
end

---Optimized treesitter foldexpr taken from LazyVim
---See: https://github.com/LazyVim/LazyVim/blob/eb525c680d0423f5addb12e10f87ce5b81fc0d9e/lua/lazyvim/util/ui.lua#L10
function M.foldexpr()
    local buf = vim.api.nvim_get_current_buf()
    if vim.b[buf].ts_folds == nil then
        if vim.bo[buf].filetype == "" then
            return "0"
        end
        if vim.bo[buf].filetype:find("dashboard") then
            vim.b[buf].ts_folds = false
        else
            vim.b[buf].ts_folds = pcall(vim.treesitter.get_parser, buf)
        end
    end
    return vim.b[buf].ts_folds and vim.treesitter.foldexpr() or "0"
end

return M
