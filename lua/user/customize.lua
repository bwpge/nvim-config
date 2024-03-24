local M = {}

M.ensure_installed = {}

local customize_path = vim.fn.stdpath("config") .. "/customize.json"
local f = io.open(customize_path, "rb")
if f then
    local data = f:read("*all")
    f:close()

    local t = vim.json.decode(data, { luanil = { object = true, array = true } })
    M = vim.tbl_deep_extend("force", M, t or {})
end

-- set proper defaults
if not M.find_command then
    M.find_command = {
        "rg",
        "--files",
        "--color",
        "never",
        "-uu",
        "-g",
        "!.git",
        "-g",
        "!node_modules",
        "-g",
        "!/target/",
        "-g",
        "!__pycache__",
    }
end

return M
