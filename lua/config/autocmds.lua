local U = require("config.utils")

-- identify large buffers to disable some settings and plugins
vim.api.nvim_create_autocmd({ "BufReadPre" }, {
    callback = function(ev)
        vim.b[ev.buf].is_large_buf = false
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(ev.buf))
        if ok and stats and stats.size > 1024 * 1024 then
            vim.b[ev.buf].is_large_buf = true
            vim.cmd.syntax("off")
            vim.opt.foldmethod = "manual"
        end
    end,
    pattern = "*",
})

-- enable treesitter highlighting
vim.api.nvim_create_autocmd("FileType", {
    callback = function(ev)
        -- skip on large buffers
        if vim.b[ev.buf].is_large_buf then
            return
        end

        local lang = vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype)
        if lang and pcall(vim.treesitter.start, ev.buf, lang) then
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            vim.wo.foldmethod = "expr"
            vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        end
    end,
})

-- warn about line endings that are different than the default fileformat
vim.api.nvim_create_autocmd("FileType", {
    callback = function(ev)
        if not ev.buf then
            return
        end
        local ft = vim.bo[ev.buf].filetype
        local bt = vim.bo[ev.buf].buftype
        if ft == "" or ft == "help" or bt == "help" then
            return
        end

        local ff_bo = vim.bo[ev.buf].fileformat
        local ff_default = vim.opt.fileformats:get()[1]
        if ff_bo and ff_default and ff_bo ~= ff_default then
            U.warn(
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
            )
        end
    end,
})

-- hide tab characters when using them e.g., with editorconfig
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        if not vim.opt.expandtab:get() then
            vim.opt.listchars:append({
                tab = "  ",
            })
        end
    end,
})

local function q_close()
    local ok, _ = pcall(vim.cmd.close)
    if ok then
        return
    end

    -- try to swap to last buffer if valid, otherwise open an empty one
    local last = vim.fn.bufnr("#")
    if last > 0 and vim.fn.bufexists(last) == 1 and vim.fn.buflisted(last) == 1 then
        vim.cmd(string.format("b%d", last))
    else
        vim.cmd.enew()
    end
end

-- close non-essential buffers with `q`
vim.api.nvim_create_autocmd("FileType", {
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
        "term",
        "toggleterm",
    },
    callback = function()
        U.nmap("q", q_close, "Close the current buffer", { buffer = true, nowait = true })
    end,
})

vim.api.nvim_create_autocmd("TermOpen", {
    callback = function(ev)
        U.set_config_keymap("term", { buffer = ev.buf })
    end,
})
