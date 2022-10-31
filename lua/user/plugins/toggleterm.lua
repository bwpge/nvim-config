local utils = require('user.core.utils')

local toggleterm = utils.require_plugin('toggleterm')
if not toggleterm then return end

local function get_shell_cmd(opts)
    opts = opts or { win32 = 'powershell' }
    local cmd_map = {
        powershell = 'powershell.exe /nologo',
        cmd = 'cmd.exe',
    }

    for feature, shell in pairs(opts) do
        if vim.fn.has(feature) == 1 then
            return cmd_map[shell] or vim.o.shell
        end
    end
end

-- TODO: check if running gitbash (doesn't play nice with nvim)
-- TODO: import navigation keymaps from module
-- TODO: implement toggleterm window navigation keymaps

toggleterm.setup({
    size = 20,
    open_mapping = '<M-`>',
    hide_numbers = true,
    autochdir = false, -- change terminal directory when nvim changes
    shade_terminals = true,
    shading_factor = 1,
    start_in_insert = true,
    insert_mappings = true,
    terminal_mappings = true,
    persist_size = false,
    direction = 'float',
    close_on_exit = true,
    shell = get_shell_cmd({ win32 = 'powershell' }),
    float_ops = {
        winblend = 10,
    },
})
