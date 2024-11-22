local U = require("user.utils")

local M = {}

local ellipsis = "…"

local custom_icons = {
    gitrebase = { "", "DevIconGitCommit" },
    help = { "󰋖", "DevIconTxt" },
    oil = { " ", "OilDir" },
    trouble = { "󰔫", "DevIconGitConfig" },
    Trouble = { "󰔫", "DevIconGitConfig" },
}

---Gets the nvim-web-devicons icon and highlight with some custom overrides.
---@param path string
---@param filetype? string
---@param buftype? string
---@return string? icon
---@return string? hl
function M.get_icon(path, filetype, buftype)
    local ok, icons = pcall(require, "nvim-web-devicons")
    if not ok then
        return
    end

    local item = custom_icons[path] or custom_icons[filetype or ""] or custom_icons[buftype or ""]
    if item then
        return unpack(item)
    end

    local icon, hl = icons.get_icon(path)
    -- use correct icon for treesitter query buffers
    if filetype == "query" then
        icon, hl = icons.get_icon_by_filetype(filetype)
    end
    if not icon and filetype then
        icon, hl = icons.get_icon_by_filetype(filetype)
    end
    if not icon and buftype then
        icon, hl = icons.get_icon_by_filetype(buftype)
    end

    return icon, hl
end

---Returns whether or not the input value could be a hash (at least 40 hex digits)
---@param s string
---@return boolean
function M.is_hash(s)
    return s and #s == 40 and s:match("^[%a%d]+$") ~= nil
end

---@param path string
---@return string
function M.shorten_dir(path)
    local parts = vim.split(path, U.path_sep, { trimempty = true }) or {}
    if #parts == 0 then
        return ""
    end
    parts[#parts] = nil

    local slice = {} ---@type string[]
    if #parts <= 2 then
        slice = parts
    else
        slice = { parts[1], ellipsis, parts[#parts] }
    end

    local s = table.concat(slice, "/")
    if #s > 0 then
        return s .. "/"
    else
        return s
    end
end

---@return string path
---@return string? pid
function M.get_term_info()
    local path = vim.api.nvim_buf_get_name(0)
    local p = vim.split(path, "//")[3] or ""

    local pid = p:match("^%d+")
    if pid then
        p = p:gsub("^%d+:", "")
    end

    return p, pid
end

local python_vars = {
    "VIRTUAL_ENV",
    "CONDA_ENV_PATH",
    "CONDA_DEFAULT_ENV",
}

---@return string?
function M.get_python_env_name()
    for _, v in ipairs(python_vars) do
        local env = vim.env[v]
        if env then
            return env
        end
    end

    return nil
end

return M
