local utils = require("user.utils")

local commands = {
    {
        "Messages",
        function(_)
            local bufnr = vim.api.nvim_create_buf(false, true)
            if bufnr == 0 then
                vim.notify("Failed to create scratch buffer", vim.log.levels.ERROR)
                return
            end

            local data = vim.fn.execute("messages", "silent")
            local content = vim.split(data, "\n")
            if content[1] == "" then
                table.remove(content, 1)
            end
            if #content == 0 then
                vim.notify("No messages to show")
                return
            end

            vim.api.nvim_buf_set_text(bufnr, 0, 0, 0, 0, content)
            vim.bo[bufnr].modifiable = false
            utils.create_window(bufnr, { title = "Messages" })
        end,
        { desc = "View :messages in a floating window" },
    },
}

for _, c in ipairs(commands) do
    vim.api.nvim_create_user_command(c[1], c[2], c[3] or {})
end
