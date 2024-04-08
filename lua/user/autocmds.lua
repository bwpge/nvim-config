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

vim.api.nvim_create_autocmd({ "FileType" }, {
    group = vim.api.nvim_create_augroup("UserFileTypeKeymaps", {}),
    pattern = "help,qf,netrw,fugitive*,git",
    callback = function()
        nmap("q", close_buf, "Close the current buffer", { buffer = true })
    end,
})
