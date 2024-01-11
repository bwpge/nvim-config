local M = {}

---Swaps to the last buffer with some extra logic.
function M.swap_last_buffer()
    -- check if current buffer is valid, don't bother swapping if not
    local curr = vim.fn.bufnr('%')
    if curr < 0 or vim.fn.bufexists(curr) == 0 or vim.fn.buflisted(curr) ~= 1 then
        return
    end

    -- swap only if last buffer is valid and listed
    local last = vim.fn.bufnr('#')
    if last > 0 and vim.fn.bufexists(last) and vim.fn.buflisted(last) == 1 then
        vim.cmd(string.format('b%d', last))
    end
end

return M
