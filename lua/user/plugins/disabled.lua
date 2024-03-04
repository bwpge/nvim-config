local prequire = require("user.utils").prequire
local c = prequire("user.customize")

local M = {}

if c and type(c.disabled) == "table" then
    for _, plugin in ipairs(c.disabled) do
        vim.validate({ name = { plugin, "string" } })
        local spec = { plugin, enabled = false }
        table.insert(M, spec)
    end
end

return M
