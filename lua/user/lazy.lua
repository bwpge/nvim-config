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

-- add LazyFile prior to loading plugins
require("user.utils").lazy_file()
require("lazy").setup("user.plugins", {
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

        local ff_bo = vim.bo[ev.buf].fileformat
        local ff_default = vim.opt.fileformats:get()[1]
        if ff_bo ~= ff_default then
            vim.notify(
                string.format(
                    "This buffer has `%s` fileformat, which does not match the default \z
                    fileformat `%s`. Different line endings may be inserted!\n  \z
                    - buf:   %d\n  \z
                    - file:  %s\n  \z
                    - id:    %d\n  \z
                    - match: %s",
                    ff_bo,
                    ff_default,
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
