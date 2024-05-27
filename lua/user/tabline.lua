local _unpack = unpack or table.unpack

local M = {}

local icons = {
    tab = "󰓩 ",
    left = "",
    right = "",
}

---@param group string
---@param field "fg"|"bg"|"sp"
---@return string?
local function extract_color(group, field)
    local hl = vim.api.nvim_get_hl(0, { name = group })
    if not hl[field] then
        return
    end

    return string.format("#%06x", hl[field])
end

---@param group string
---@return string?
local function extract_fg(group)
    return extract_color(group, "fg")
end

---@param group string
---@return string?
local function extract_bg(group)
    return extract_color(group, "bg")
end

---Builds tabline highlight groups based on `lualine` theme colors.
---
---This function must be called after the theme is setup so lualine colors can
---be set correctly.
function M.setup()
    local fg_accent = extract_bg("lualine_a_normal")
    local fg_dark = extract_fg("lualine_a_normal")
    local bg_active = extract_bg("lualine_a_insert")
    local bg_inactive = extract_bg("lualine_b_normal")
    local bg_reset = extract_bg("Normal")

    local function create_hls(name, hl_fg, hl_bg, bold)
        vim.api.nvim_set_hl(0, name .. "Gap", { fg = bg_reset, bg = hl_bg })
        vim.api.nvim_set_hl(0, name, { fg = hl_fg, bg = hl_bg, bold = bold or false })
        vim.api.nvim_set_hl(0, name .. "End", { fg = hl_bg, bg = bg_reset })
    end

    for _, args in ipairs({
        { "TabLineHeader", fg_dark, fg_accent },
        { "TabLineActive", fg_dark, bg_active, true },
        { "TabLineInactive", fg_accent, bg_inactive, true },
        { "TabLineCwd", fg_accent, bg_inactive },
    }) do
        create_hls(_unpack(args))
    end
end

---Returns the working directory for a given tab id.
---@param id integer
---@return string
local function get_tab_cwd(id)
    local cwd = vim.fn.fnamemodify(vim.fn.getcwd(-1, id), ":~"):gsub("\\", "/")
    return cwd
end

---@alias Tab { id: integer, cwd: string, active: boolean }

---Returns a list of tabs with id, working directory, and active flag.
---
---The `cwd` field indicates the active tab's working directory.
---@return { cwd: string, [integer]: Tab }
local function get_tabs()
    local tabs = { cwd = "" }
    local curr_id = vim.fn.tabpagenr()

    for id, _ in ipairs(vim.api.nvim_list_tabpages()) do
        local active = curr_id == id
        local cwd = get_tab_cwd(id)

        if active then
            tabs.cwd = cwd
        end
        table.insert(tabs, { id = id, cwd = cwd, active = active })
    end

    return tabs
end

---Renders a block with left or right alignment.
---@param dir "left"|"right"
---@param content any
---@param base_hl string
---@param no_prefix? boolean
---@return string
local function render_block(dir, content, base_hl, no_prefix)
    local hl = "%#" .. base_hl .. "#"
    local hl_end = "%#" .. base_hl .. "End#"
    local sep = icons[dir]
    local prefix = no_prefix and "" or ("%#" .. base_hl .. "Gap#" .. sep)

    if dir == "right" then
        return hl_end .. sep .. hl .. " " .. content .. " " .. prefix
    else
        return prefix .. hl .. " " .. content .. " " .. hl_end .. sep
    end
end

---Similar to `render_block`, but makes tabs clickable.
---@param dir "left"|"right"
---@param tab Tab
---@return string
local function render_tab(dir, tab)
    local hl = tab.active and "TabLineActive" or "TabLineInactive"
    return "%" .. tab.id .. "T" .. render_block(dir, tab.id, hl) .. "%T"
end

---Returns the rendered tabline string for `vim.opt.tabline`.
---@return string
function M.render()
    local tabs = get_tabs()
    local t = {}
    for _, tab in ipairs(tabs) do
        -- local hl = tab.active and "TabLineActive" or "TabLineInactive"
        -- local s = render_block("left", tab.id, hl)
        table.insert(t, render_tab("left", tab))
    end

    return render_block("left", icons.tab, "TabLineHeader", true)
        .. table.concat(t, "")
        .. render_block("left", tabs.cwd, "TabLineCwd")
        .. "%#TabLineFill#%="
end

return M
