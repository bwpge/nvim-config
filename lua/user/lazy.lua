local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

---@diagnostic disable-next-line: inject-field
vim.g.lazy_events_config = {
    simple = {
        LazyFile = { "BufReadPost", "BufNewFile", "BufWritePre" },
    },
    projects = {
        cmake = { "CmakeLists.txt" },
        go = { "go.mod", "go.sum" },
        nvim = { "lua/" },
        rust = { "Cargo.toml", "Cargo.lock" },
    },
    custom = {
        StartWithDir = {
            event = "BufEnter",
            once = true,
            cond = function()
                local arg = vim.fn.argv(0)
                if arg == "" then
                    return
                end

                local stats = vim.uv.fs_stat(arg)
                return (stats and stats.type == "directory") or false
            end,
        },
    },
}

require("lazy").setup({
    spec = {
        { "bwpge/lazy-events.nvim", import = "lazy-events.import", lazy = false },
        { import = "user.plugins" },
    },
    defaults = {
        lazy = true,
    },
    install = {
        colorscheme = { require("user.theme").name },
    },
    change_detection = {
        notify = false,
    },
    performance = {
        cache = {
            enabled = true,
        },
        rtp = {
            disabled_plugins = {
                "gzip",
                "rplugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
    ui = {
        border = "single",
        icons = {
            task = " ",
        },
    },
})

vim.keymap.set("n", "<leader>pl", "<cmd>Lazy<cr>", { desc = "Open Lazy status window" })
