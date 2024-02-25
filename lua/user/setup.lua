local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- load plugins from modules
require("lazy").setup({
    { import = "user.plugins" },
    { import = "user.plugins.themes" },
}, {
    install = {
        colorscheme = { require("user.theme").name },
    },
    change_detection = {
        notify = false,
    },
    ui = {
        border = "single",
    },
})

-- warn about line endings that are different than the default fileformat
vim.api.nvim_create_autocmd({ "FileType" }, {
    callback = function(ev)
        if not ev.buf then
            return
        end
        local ft = vim.fn.getbufvar(ev.buf, "&filetype")
        if ft == "" or ft == "help" then
            return
        end

        local bo_ff = vim.bo[ev.buf].fileformat
        local def_ff = vim.opt.fileformats:get()[1]
        if bo_ff ~= def_ff then
            vim.notify(
                string.format(
                    "This buffer has `%s` fileformat, which does not match the default \z
                    fileformat `%s`. Different line endings may be inserted!\n  \z
                    - buf:   %d\n  \z
                    - file:  %s\n  \z
                    - id:    %d\n  \z
                    - match: %s",
                    bo_ff,
                    def_ff,
                    ev.buf,
                    ev.file,
                    ev.id,
                    ev.match
                ),
                vim.log.levels.WARN
            )
        end
    end,
})
