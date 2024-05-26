local prequire = require("user.utils").prequire
local C = prequire("user.customize")

local M = {}

if C and type(C.disabled) == "table" then
    for _, plugin in ipairs(C.disabled) do
        vim.validate({ name = { plugin, "string" } })
        local spec = { plugin, enabled = false }
        table.insert(M, spec)
    end
end

return M
