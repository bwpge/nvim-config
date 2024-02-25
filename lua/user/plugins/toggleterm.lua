local utils = require("user.utils")
local lazy_nmap = utils.lazy_nmap

---Gets the shell string for the integrated terminal depending on platform.
---@return string?
local function get_shell()
    if utils.is_windows then
        if vim.fn.executable("pwsh") ~= 0 then
            return "pwsh -nologo"
        else
            return "powershell /nologo"
        end
    end
end

return {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = { "ToggleTerm", "TermExec" },
    keys = {
        lazy_nmap(
            "<leader>`",
            "<cmd>ToggleTerm direction=float<cr>",
            "Toggle floating integrated terminal"
        ),
        lazy_nmap(
            "<leader>~",
            "<cmd>ToggleTerm direction=horizontal<cr>",
            "Toggle integrated terminal"
        ),
    },
    opts = {
        shell = get_shell(),
        shade_terminals = false,
        direction = "float",
        highlights = {
            FloatBorder = { link = "TelescopePromptBorder" },
        },
    },
}
