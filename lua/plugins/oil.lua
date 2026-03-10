local U = require("config.utils")
local nmap = U.lazy_nmap

local function close_and_discard()
    require("oil").discard_all_changes()
    require("oil").close()
end

return {
    {
        "stevearc/oil.nvim",
        event = "VeryLazy",
        cmd = "Oil",
        keys = {
            nmap("-", "<cmd>Oil --float<cr>", "Edit directory"),
        },
        opts = {
            default_file_explorer = false,
            keymaps = {
                ["q"] = { close_and_discard, mode = "n" },
                ["<Esc>"] = { close_and_discard, mode = "n" },
                ["<F5>"] = "actions.refresh",
            },
            float = {
                max_width = 0.5,
                max_height = 0.5,
                border = "single",
                override = function(conf)
                    return vim.tbl_extend("force", conf, {
                        title = "Test",
                        title_pos = "center",
                    })
                end,
            },
            view_options = {
                show_hidden = true,
                natural_order = true,
                is_always_hidden = function(name, _)
                    return name == ".." or name == ".git"
                end,
            },
        },
    },
}
