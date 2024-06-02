local nmap = require("user.utils").nmap

-- warn about line endings that are different than the default fileformat
vim.api.nvim_create_autocmd({ "FileType" }, {
    callback = function(e)
        if not e.buf then
            return
        end
        local ft = vim.bo[e.buf].filetype
        local bt = vim.bo[e.buf].buftype
        if ft == "" or ft == "help" or bt == "help" then
            return
        end

        local ff_bo = vim.bo[e.buf].fileformat
        local ff_default = vim.opt.fileformats:get()[1]
        if ff_bo and ff_default and ff_bo ~= ff_default then
            require("user.utils").notify_warn(
                "This buffer has `%s` fileformat, which does not match the default \z
                    fileformat `%s`. Different line endings may be inserted!\n  \z
                    - buf:   %d\n  \z
                    - file:  %s\n  \z
                    - id:    %d\n  \z
                    - match: %s",
                ff_bo,
                ff_default,
                e.buf,
                e.file,
                e.id,
                e.match
            )
        end
    end,
})

-- close non-essential buffers with `q`
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = {
        "checkhealth",
        "fugitive*",
        "git",
        "help",
        "lspinfo",
        "netrw",
        "notify",
        "qf",
        "query",
    },
    callback = function()
        nmap("q", vim.cmd.close, "Close the current buffer", { buffer = true })
    end,
})
