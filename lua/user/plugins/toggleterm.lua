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
    {
        "ryanmsnyder/toggleterm-manager.nvim",
        opts = {
            titles = {
                prompt = "Terminals",
            },
            results = {
                fields = { "state", "space", "term_icon", "space", "term_name", "space", "bufname" },
            },
        },
        config = function(_, opts)
            local manager = require("toggleterm-manager")
            local create_action = {
                action = manager.actions.create_term,
                exit_on_action = true,
            }
            local create_hidden_action = {
                action = manager.actions.create_term,
                exit_on_action = false,
            }
            local open_action = {
                action = manager.actions.open_term,
                exit_on_action = true,
            }
            local del_action = {
                action = manager.actions.delete_term,
                exit_on_action = false,
            }

            opts.mappings = {
                i = {
                    ["<CR>"] = open_action,
                    ["<C-d>"] = del_action,
                    ["<C-n>"] = create_action,
                    ["<C-h>"] = create_hidden_action,
                },
                n = {
                    ["<CR>"] = open_action,
                    ["<C-d>"] = del_action,
                    ["<C-n>"] = create_action,
                    ["<C-h>"] = create_hidden_action,
                },
            }
            manager.setup(opts)
        end,
    },
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        cmd = { "ToggleTerm", "TermExec", "TermSelect" },
        opts = {
            shell = get_shell(),
            shade_terminals = false,
            direction = "float",
            highlights = {
                FloatBorder = { link = "ToggleTermBorder" },
            },
        },
        init = function() end,
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
    },
}
