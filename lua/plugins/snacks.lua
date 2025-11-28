local U = require("config.utils")
U.set_config_keymap("snacks")

return {
    "folke/snacks.nvim",
    priority = 999,
    lazy = false,
    opts = {
        picker = {
            prompt = " ",
            layout = {
                layout = {
                    width = 0.75,
                    height = 0.75,
                },
            },
            win = {
                input = {
                    keys = {
                        ["<Esc>"] = { "close", mode = { "n", "i" } },
                        ["<PageUp>"] = { "list_scroll_up", mode = { "n", "i" } },
                        ["<PageDown>"] = { "list_scroll_down", mode = { "n", "i" } },
                        ["<C-Home>"] = { "list_top", mode = { "n", "i" } },
                        ["<C-End>"] = { "list_bottom", mode = { "n", "i" } },
                        ["<S-Left>"] = { "preview_scroll_left", mode = { "n", "i" } },
                        ["<S-Down>"] = { "preview_scroll_down", mode = { "n", "i" } },
                        ["<S-Up>"] = { "preview_scroll_up", mode = { "n", "i" } },
                        ["<S-Right>"] = { "preview_scroll_right", mode = { "n", "i" } },
                        ["<C-q>"] = { "qf_custom", mode = { "n", "i" } },
                    },
                },
            },
            actions = {
                qf_custom = function(picker)
                    picker:close()
                    local sel = picker:selected()
                    local items = #sel > 0 and sel or picker:items()

                    local qf = {} ---@type vim.quickfix.entry[]
                    for _, item in ipairs(items) do
                        local text = item.line
                            or item.comment
                            or item.label
                            or item.name
                            or item.detail
                            or item.text
                            or ""
                        text = text:gsub("\\", "/")
                        qf[#qf + 1] = {
                            ---@diagnostic disable-next-line: undefined-global
                            filename = Snacks.picker.util.path(item),
                            text = text,
                            bufnr = item.buf,
                            lnum = item.pos and item.pos[1] or 1,
                            col = item.pos and item.pos[2] + 1 or 1,
                            end_lnum = item.end_pos and item.end_pos[1] or nil,
                            end_col = item.end_pos and item.end_pos[2] + 1 or nil,
                            pattern = item.search,
                            type = ({ "E", "W", "I", "N" })[item.severity],
                            valid = true,
                        }
                    end

                    local qf_cmd = ""
                    if vim.fn.exists(":Trouble") == 0 then
                        qf_cmd = "copen"
                    else
                        qf_cmd = "Trouble qflist"
                    end

                    vim.fn.setqflist(qf)
                    vim.cmd("botright " .. qf_cmd)
                end,
            },
        },
        input = {
            icon = "",
            win = {
                style = {
                    backdrop = false,
                    position = "float",
                    border = {
                        "▕",
                        { " ", "SnacksInputTitle" },
                        "▏",
                        "▏",
                        " ",
                        "▔",
                        " ",
                        "▕",
                    },
                    title_pos = "left",
                    height = 1,
                    width = 35,
                    relative = "cursor",
                    noautocmd = true,
                    row = -3,
                    wo = {
                        cursorline = false,
                    },
                    bo = {
                        filetype = "snacks_input",
                        buftype = "prompt",
                    },
                    b = {
                        completion = false, -- disable blink completions in input
                    },
                    keys = {
                        n_esc = { "<esc>", { "cmp_close", "cancel" }, mode = "n", expr = true },
                        i_esc = {
                            "<esc>",
                            { "cmp_close", "cancel" },
                            mode = "i",
                            expr = true,
                        },
                        i_cr = {
                            "<cr>",
                            { "cmp_accept", "confirm" },
                            mode = { "i", "n" },
                            expr = true,
                        },
                        i_tab = {
                            "<tab>",
                            { "cmp_select_next", "cmp" },
                            mode = "i",
                            expr = true,
                        },
                        i_ctrl_w = { "<c-w>", "<c-s-w>", mode = "i", expr = true },
                        i_up = { "<up>", { "hist_up" }, mode = { "i", "n" } },
                        i_down = { "<down>", { "hist_down" }, mode = { "i", "n" } },
                        q = "cancel",
                    },
                },
            },
            expand = true,
        },
    },
}
