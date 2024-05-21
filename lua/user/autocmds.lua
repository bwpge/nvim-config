local nmap = require("user.utils").nmap

local function close_buf()
    if vim.bo.filetype:match("^fugitive") then
        ---@diagnostic disable-next-line: param-type-mismatch
        if vim.fn.bufnr("$") == 1 then
            return vim.cmd.quit()
        else
            return vim.cmd.bdelete()
        end
    end

    return vim.cmd.quit()
end

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
                    e.buf,
                    e.file,
                    e.id,
                    e.match
                ),
                vim.log.levels.WARN
            )
        end
    end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
    group = vim.api.nvim_create_augroup("UserFileTypeKeymaps", {}),
    pattern = "help,qf,netrw,fugitive*,git",
    callback = function()
        nmap("q", close_buf, "Close the current buffer", { buffer = true })
    end,
})
