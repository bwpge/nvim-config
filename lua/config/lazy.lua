local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        lazyrepo,
        lazypath,
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

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
        { import = "plugins" },
    },
    defaults = {
        lazy = true,
    },
    install = {
        colorscheme = { "catppuccin" },
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
