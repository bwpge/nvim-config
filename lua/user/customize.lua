local M = {}

local customize_path = vim.fn.stdpath("config") .. "/customize.json"
local f = io.open(customize_path, "rb")
if f then
    local data = f:read("*all")
    f:close()

    local t = vim.json.decode(data)
    M = vim.tbl_deep_extend("force", M, t or {})
end

return M
