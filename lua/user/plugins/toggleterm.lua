local utils = require("user.utils")
local kmap = utils.kmap

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
    dependencies = {
        "bwpge/toggleterm-ext.nvim",
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
        opts = {
            expand_cmd = true,
            input = {
                title = "Launch terminal",
            },
        },
    },
    cmd = { "ToggleTerm", "TermExec", "TermExecInput" },
    opts = {
        shell = get_shell(),
        shade_terminals = false,
        direction = "float",
        highlights = {
            FloatBorder = { link = "TelescopePromptBorder" },
        },
    },
    config = function(_, opts)
        require("toggleterm").setup(opts)

        vim.api.nvim_create_autocmd({ "TermOpen" }, {
            pattern = { "term://*toggleterm*" },
            callback = function()
                kmap(
                    "t",
                    "<M-[>",
                    [[<C-\><C-n>]],
                    "Return to normal mode from terminal mode",
                    { buffer = 0, silent = true, noremap = true }
                )
                kmap(
                    "t",
                    "<Esc>",
                    "<cmd>q<cr>",
                    "Close integrated terminal",
                    { buffer = 0, silent = true, noremap = true }
                )
            end,
        })
    end,
}
