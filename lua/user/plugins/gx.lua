local kmap = require("user.utils").lazy_kmap

-- copied from lazy.nvim
-- see: https://github.com/folke/lazy.nvim/blob/aedcd79811d491b60d0a6577a9c1701063c2a609/lua/lazy/util.lua#L28-42
local function get_open_browser_app()
    if vim.fn.has("win32") == 1 then
        return "explorer"
    elseif vim.fn.has("macunix") == 1 then
        return "open"
    else
        if vim.fn.executable("xdg-open") == 1 then
            return "xdg-open"
        elseif vim.fn.executable("wslview") == 1 then
            return "wslview"
        else
            return "open"
        end
    end
end

return {
    "chrishrb/gx.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "Browse" },
    keys = {
        kmap({ "n", "x" }, "gx", "<cmd>Browse<cr>", "Open in web browser"),
    },
    init = function()
        vim.g.netrw_nogx = 1 -- disable netrw gx
    end,
    opts = {
        open_browser_app = get_open_browser_app(),
        handlers = {
            plugin = true,
            github = false,
            brewfile = false,
            package_json = false,
            search = false,
        },
    },
    config = function(_, opts)
        local gx = require("gx")
        gx.setup(opts)

        -- needed because gx.nvim always tries to use "start explorer.exe" args
        -- on windows, and an empty list doesn't overwrite it
        gx.options.open_browser_args = {}

        -- patch gx.shell executor with similar to lazy.nvim handler
        -- see: https://github.com/folke/lazy.nvim/blob/aedcd79811d491b60d0a6577a9c1701063c2a609/lua/lazy/util.lua#L44-L51
        local shell = require("gx.shell")
        local patched = function(command, args, url)
            local cmd = { command }
            for _, arg in ipairs(args) do
                table.insert(cmd, arg)
            end
            table.insert(cmd, url)

            local ret = vim.fn.jobstart(cmd, { detach = true })
            if ret <= 0 then
                local msg = {
                    "Failed to open url",
                    ret,
                    vim.inspect(cmd),
                }
                vim.notify(table.concat(msg, "\n"), vim.log.levels.ERROR)
            end
        end
        shell.execute_with_error = patched
    end,
}
