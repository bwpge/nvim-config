local M = {}

M.names = {
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
    ["\22"] = "VISUAL BLOCK",
    ["\22s"] = "VISUAL BLOCK",
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

M.colors = {
    NORMAL = "blue",
    INSERT = "green",
    VISUAL = "purple",
    COMMAND = "orange",
    SELECT = "purple",
    REPLACE = "cyan",
    ["OP-PENDING"] = "cyan",
    TERMINAL = "red",
}

local default_color = "red"

---Returns the appropriate color for the current mode.
---@return string
function M.get_color()
    local mode = vim.api.nvim_get_mode().mode
    local key = M.names[mode]

    if key:find("REPLACE") ~= nil then
        key = "REPLACE"
    elseif key:find("VISUAL") ~= nil then
        key = "VISUAL"
    end

    return M.colors[key] or default_color
end

return M
