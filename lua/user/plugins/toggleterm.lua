local c = require("user.customize")
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
        opts = utils.merge_custom_opts("toggleterm", {
            size = function(term)
                if term.direction == "horizontal" then
                    return math.min(20, vim.o.lines * 0.4)
                elseif term.direction == "vertical" then
                    return vim.o.columns * 0.4
                end
            end,
            shell = get_shell(),
            shade_terminals = false,
            direction = c.term_direction or "horizontal",
            highlights = {
                Normal = { link = "Normal" },
                NormalFloat = { link = "TelescopeNormal" },
                FloatBorder = { link = "TelescopePreviewBorder" },
            },
            float_opts = {
                -- use same dimensions as telescope
                width = math.floor(0.87 * vim.o.columns + 0.5),
                height = math.floor(0.75 * vim.o.lines + 0.5),
            },
            on_create = function(term)
                -- set empty term name to cmd that opened it. this doesn't
                -- initially show if opened in a floating window
                if not term.display_name or #term.display_name == 0 then
                    local name = vim.split(term.name, " ")[1]
                    name = vim.split(name, ";")[1]
                    term.display_name = vim.fn.fnamemodify(name, ":t")
                end

                -- set terminal keymaps
                vim.keymap.set({ "n", "t" }, "<C-d>", function()
                    vim.api.nvim_buf_delete(term.bufnr, { force = true })
                end, { buffer = term.bufnr, desc = "Delete toggleterm terminal" })
                vim.keymap.set({ "n", "t" }, "<C-n>", function()
                    require("toggleterm.terminal").Terminal:new({ hidden = false }):open()
                end, { buffer = term.bufnr, desc = "Create new toggleterm terminal" })
            end,
        }),
        init = function() end,
        config = function(_, opts)
            require("toggleterm").setup(opts)

            vim.api.nvim_create_autocmd({ "TermOpen" }, {
                pattern = { "term://*toggleterm*" },
                callback = function()
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
