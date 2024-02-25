local kmap = require("user.utils").lazy_kmap

return {
    "chrishrb/gx.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "Browse" },
    keys = {
        kmap({ "n", "x" }, "gx", "<cmd>Browse<cr>", "Open in web browser"),
    },
    init = function()
        vim.g.netrw_nogx = 1 -- disable netrw gx
    end,
    config = function()
        require("gx").setup({
            handlers = {
                plugin = true,
                github = false,
                brewfile = false,
                package_json = false,
                search = false,
            },
        })
    end,
}
