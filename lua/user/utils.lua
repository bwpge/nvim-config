local M = {}

M.is_windows = vim.uv.os_uname().version:match("Windows") or vim.fn.has("win32") ~= 0

M.path_sep = package.config:sub(1, 1)

---Shorthand for `vim.notify(..., level)` with a formatted message.
---@param level integer
---@param fmt string
---@param ... any
function M.notify(level, fmt, ...)
    vim.notify(string.format(fmt, ...), level)
end

---Shorthand for errors with `vim.notify` and a formatted message.
---@param fmt string
---@param ... any
function M.notify_error(fmt, ...)
    M.notify(vim.log.levels.ERROR, fmt, ...)
end

---Shorthand for a warning with `vim.notify` and a formatted message.
---@param fmt string
---@param ... any
function M.notify_warn(fmt, ...)
    M.notify(vim.log.levels.WARN, fmt, ...)
end

---Shorthand for `vim.notify` with a formatted message.
---@param fmt string
---@param ... any
function M.notify_info(fmt, ...)
    M.notify(vim.log.levels.INFO, fmt, ...)
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

---Creates a normal mode keymap with sensible defaults.
---@param lhs string
---@param rhs string|function
---@param desc string?
---@param opts table?
function M.nmap(lhs, rhs, desc, opts)
    M.kmap("n", lhs, rhs, desc, opts)
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

---Swaps to the last buffer with some extra logic.
function M.swap_last_buffer()
    -- check if current buffer is valid, don't bother swapping if not
    ---@diagnostic disable-next-line: param-type-mismatch
    local curr = vim.fn.bufnr("%")
    if curr < 0 or vim.fn.bufexists(curr) == 0 or vim.fn.buflisted(curr) ~= 1 then
        return
    end

    -- swap only if last buffer is valid and listed
    ---@diagnostic disable-next-line: param-type-mismatch
    local last = vim.fn.bufnr("#")
    if last > 0 and vim.fn.bufexists(last) and vim.fn.buflisted(last) == 1 then
        vim.cmd(string.format("b%d", last))
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

---Adds support for `LazyFile` events. This function is odified from LazyVim, see:
---https://github.com/LazyVim/LazyVim/blob/e1d39b624f8dffadd787de5a83c81540919d953e/lua/lazyvim/util/plugin.lua#L59-L125
function M.lazy_file()
    local use_lazy_file = vim.fn.argc(-1) > 0
    local lazy_file_events = { "BufReadPost", "BufNewFile", "BufWritePre" }

    -- Add support for the LazyFile event
    local Event = require("lazy.core.handler.event")

    if use_lazy_file then
        -- We'll handle delayed execution of events ourselves
        Event.mappings.LazyFile = { id = "LazyFile", event = "User", pattern = "LazyFile" }
        Event.mappings["User LazyFile"] = Event.mappings.LazyFile
    else
        -- Don't delay execution of LazyFile events, but let lazy know about the mapping
        Event.mappings.LazyFile = { id = "LazyFile", event = lazy_file_events }
        Event.mappings["User LazyFile"] = Event.mappings.LazyFile
        return
    end

    local events = {} ---@type {event: string, buf: number, data?: any}[]

    local done = false
    local function load()
        if #events == 0 or done then
            return
        end
        done = true
        vim.api.nvim_del_augroup_by_name("lazy_file")

        ---@type table<string,string[]>
        local skips = {}
        for _, event in ipairs(events) do
            skips[event.event] = skips[event.event] or Event.get_augroups(event.event)
        end

        vim.api.nvim_exec_autocmds("User", { pattern = "LazyFile", modeline = false })
        for _, event in ipairs(events) do
            if vim.api.nvim_buf_is_valid(event.buf) then
                Event.trigger({
                    event = event.event,
                    exclude = skips[event.event],
                    data = event.data,
                    buf = event.buf,
                })
                if vim.bo[event.buf].filetype then
                    Event.trigger({
                        event = "FileType",
                        buf = event.buf,
                    })
                end
            end
        end
        vim.api.nvim_exec_autocmds("CursorMoved", { modeline = false })
        events = {}
    end

    -- schedule wrap so that nested autocmds are executed
    -- and the UI can continue rendering without blocking
    load = vim.schedule_wrap(load)

    vim.api.nvim_create_autocmd(lazy_file_events, {
        group = vim.api.nvim_create_augroup("lazy_file", { clear = true }),
        callback = function(event)
            table.insert(events, event)
            load()
        end,
    })
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

---Returns customized options for `key` with an input table.
---@param name string
---@param opts table
---@return table
function M.merge_custom_opts(name, opts)
    local t = vim.tbl_deep_extend("force", opts, require("user.customize")[name] or {})
    M.deep_replace(t, vim.NIL, nil)
    return t
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
        -- style = "minimal",
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

---Extends gx behavior to open GitHub pages for short plugin names, e.g., `foo/bar`.
---
---Should be used in a keymap with `{ expr = true }`.
---@param fallback function?
---@return function
function M.gx_extended_fn(fallback)
    return function()
        local word = vim.fn.expand("<cWORD>"):match("[\"']([%a_%.%-]+/[%a_%.%-]+)[\"']")
        if word then
            vim.ui.open("https://github.com/" .. word)
        elseif fallback then
            fallback()
        end
    end
end

---comment
---@param path string
---@param mode string? Mode to open the file with (default: "rb")
---@return string
function M.read_file_to_string(path, mode)
    mode = mode or "rb"
    local f = io.open(path, mode)
    if not f then
        error(string.format("failed to read file: %s", path), 2)
        return ""
    end

    local data = f:read("*a")
    f:close()
    return data or ""
end

---Reads a JSON file and decodes it to a lua table.
---@param path string
---@param opts table?
---@return table
function M.json_decode_file(path, opts)
    local data = M.read_file_to_string(path)
    return vim.json.decode(data, opts or {})
end

return M
