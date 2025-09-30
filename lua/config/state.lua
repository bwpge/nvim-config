local M = {}

local state_file = vim.fn.stdpath("data") .. "/confstate.json"

local function load_state()
    local f = io.open(state_file, "r")
    if not f then
        return {}
    end

    local data = f:read("*a")
    f:close()
    return vim.json.decode(data)
end

local state = load_state()

---Retruns a value from the state table
---@param key string
---@return any
function M.get(key)
    return state[key]
end

---Sets a value in the state table and writes it to disk
---@param key string
---@param value any
function M.set(key, value)
    state[key] = value
    local data = vim.json.encode(state)

    local f = io.open(state_file, "w+")
    if f then
        f:write(data)
        f:close()
    end
end

---Toggles a value in the state table and writes it to disk.
---@param key string
---@return boolean
function M.toggle(key)
    local value = not state[key]
    M.set(key, value)
    return value
end

return M
