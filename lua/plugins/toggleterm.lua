local U = require("config.utils")
local kmap = U.lazy_kmap
local nmap = U.lazy_nmap

---Gets the shell string for the integrated terminal depending on platform.
---@return string?
local function get_shell()
    if U.is_windows then
        if vim.fn.executable("pwsh") ~= 0 then
            return "pwsh -nologo"
        else
            return "powershell /nologo"
        end
    end
end

-- enables number prefix to open specific terminal id
local function toggleterm_cmd(dir)
    return string.format(
        '<cmd>execute v:count . "ToggleTerm%s"<cr>',
        dir and (" direction=" .. dir) or ""
    )
end

return {
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        cmd = { "ToggleTerm", "TermExec", "TermSelect" },
        keys = {
            kmap({ "n", "i", "t" }, "<M-`>", toggleterm_cmd(), "Toggle integrated terminal"),
            nmap("<leader>`f", toggleterm_cmd("float"), "Toggle floating integrated terminal"),
            nmap("<leader>`v", toggleterm_cmd("vertical"), "Toggle vertical integrated terminal"),
            nmap(
                "<leader>`h",
                toggleterm_cmd("horizontal"),
                "Toggle horizontal integrated terminal"
            ),
        },
        opts = {
            size = function(term)
                if term.direction == "horizontal" then
                    return math.min(20, vim.o.lines * 0.4)
                elseif term.direction == "vertical" then
                    return vim.o.columns * 0.4
                end
            end,
            shell = get_shell(),
            shade_terminals = false,
            direction = "horizontal",
            highlights = {
                Normal = { link = "Normal" },
                NormalFloat = { link = "NormalFloat" },
                FloatBorder = { link = "FloatBorder" },
                -- fix statusline colors with heirline
                StatusLine = { link = "StatusLine" },
                StatusLineNC = { link = "StatusLineNC" },
            },
            float_opts = {
                title_pos = "center",
                border = "single",
                -- use same dimensions as telescope
                width = math.floor(0.87 * vim.o.columns + 0.5),
                height = math.floor(0.75 * vim.o.lines + 0.5),
            },
            on_create = function(term)
                -- if empty terminal name, set to cmd that opened it
                -- (this doesn't initially show if opened in a floating window)
                if not term.display_name or #term.display_name == 0 then
                    local name = vim.split(term.name, " ")[1]
                    name = vim.split(name, ";")[1]
                    term.display_name = vim.fn.fnamemodify(name, ":t")
                end

                -- set buffer-specifc keymaps
                vim.keymap.set({ "n" }, "<C-d>", function()
                    vim.api.nvim_buf_delete(term.bufnr, { force = true })
                end, { buffer = term.bufnr, desc = "Delete toggleterm terminal" })
                vim.keymap.set({ "n", "t" }, "<C-n>", function()
                    require("toggleterm.terminal").Terminal:new({ hidden = false }):open()
                end, { buffer = term.bufnr, desc = "Create new toggleterm terminal" })
            end,
        },
    },
}
