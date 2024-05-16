local utils = require("user.utils")

local commands = {
    {
        "Output",
        function(ctx)
            local bufnr = vim.api.nvim_create_buf(false, true)
            if bufnr == 0 then
                vim.notify("Failed to create scratch buffer", vim.log.levels.ERROR)
                return
            end

            local data = vim.fn.execute(ctx.args)
            local lines = vim.split(data, "\n")
            if lines[1] == "" then
                table.remove(lines, 1)
            end

            vim.api.nvim_buf_set_text(bufnr, 0, 0, 0, 0, lines)
            vim.bo[bufnr].modifiable = false
            local win = utils.create_window(bufnr, { title = "Messages" })
            vim.api.nvim_win_set_cursor(win, { #lines, 0 })
        end,
        {
            nargs = "+",
            complete = "command",
            desc = "Capture command output in a floating window",
        },
    },
    {
        "Config",
        function(_)
            local conf_path = vim.fn.stdpath("config")
            for i = 1, vim.fn.tabpagenr("$") do
                local twd = vim.fn.getcwd(0, i)
                if twd == conf_path then
                    if i == vim.fn.tabpagenr() then
                        vim.notify("Config is already active (tab " .. i .. ")")
                    else
                        vim.notify("Switching to config (tab " .. i .. ")")
                        vim.cmd.norm(i .. "gt")
                    end
                    return
                end
            end

            vim.notify("Opening config in new tab")
            vim.cmd.tabnew()
            vim.cmd.tcd(conf_path)
        end,
        { desc = "Open Neovim config in a new tab (or switch to that tab)" },
    },
}

for _, c in ipairs(commands) do
    vim.api.nvim_create_user_command(c[1], c[2], c[3] or {})
end
