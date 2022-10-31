local M = {}

---Swaps to the last buffer in a smarter way.
--Only swaps buffers if the last buffer (e.g., `#`) exists and is listed.
--Otherwise, does nothing.
function M.last_buffer_swap()
    -- check if current buffer is valid and listed
    -- don't bother swapping if not
    local cbuf = vim.fn.bufnr('%')
    if cbuf < 0 or vim.fn.bufexists(cbuf) == 0 or vim.fn.buflisted(cbuf) ~= 1 then
        return
    end

    -- swap only if last buffer is valid and listed
    local buf = vim.fn.bufnr('#')
    if buf > 0 and vim.fn.bufexists(buf) and vim.fn.buflisted(buf) == 1 then
        vim.cmd(string.format('b%d', buf))
    end
end

---Returns the first found build command from an optional list.
---@param commands table|nil Optional list of commands to check
---@return string|nil
function M.get_build_system(commands)
    commands = commands or { 'cmake', 'make' }
    for _, cmd in pairs(commands) do
        if vim.fn.executable(cmd) == 1 then
            return cmd
        end
    end
end

---Checks if there is any known build system executable in the `$PATH`.
---@return boolean
function M.has_build_system()
    return M.get_build_system() ~= nil
end

---Tries to import the given plugin module and notifies an error if failed.
---@param name string Name of the plugin
---@param opts table|nil Options for message handling
---@return any
function M.require_plugin(name, opts)
    assert(type(name) == 'string', 'expected a string, got ' .. type(name))
    assert(name ~= '', 'plugin name must be a valid, non-empty string')

    local ok, plugin = pcall(require, name)
    if ok then return plugin end

    local __opts = {
        level = 'error',
        notify = true,
        fmt = "Failed to load plugin '%s'",
        title = 'Plugin not found',
    }
    if opts then
        for k,v in pairs(opts) do
            __opts[k] = v
        end
    end

    local msg = string.format(__opts.fmt, name)
    if __opts.notify then
        vim.notify(msg, __opts.level, { title = 'Plugin not found' })
    else
        error(msg)
    end

    return nil
end

return M
