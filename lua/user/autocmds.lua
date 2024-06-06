local nmap = require("user.utils").nmap

-- render as quickly as possible when opening a file (taken from LazyVim)
vim.api.nvim_create_autocmd("BufReadPost", {
    once = true,
    callback = function(event)
        -- Skip if we already entered vim
        if vim.v.vim_did_enter == 1 then
            return
        end

        -- Try to guess the filetype (may change later on during Neovim startup)
        local ft = vim.filetype.match({ buf = event.buf })
        if ft then
            -- Add treesitter highlights and fallback to syntax
            local lang = vim.treesitter.language.get_lang(ft)
            if not (lang and pcall(vim.treesitter.start, event.buf, lang)) then
                vim.bo[event.buf].syntax = ft
            end

            -- Trigger early redraw
            vim.cmd.redraw()
        end
    end,
})

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
