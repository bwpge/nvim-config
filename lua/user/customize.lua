local M = {}

local customize_path = vim.fn.stdpath("config") .. "/customize.json"
local f = io.open(customize_path, "rb")
if f then
    local s = f:read("*all")
    M = vim.json.decode(s, { luanil = { object = true, array = true } })
    f:close()
end

return M
