local U = require("config.utils")

-- customize lsp settings
local configs = {
    gopls = {
        semanticTokens = true,
        staticcheck = true,
        analyses = {
            unusedparams = true,
            unusedvariable = true,
            unusedresult = true,
        },
    },
    lua_ls = {
        rename = "Lua",
        hint = {
            enable = true,
            arrayIndex = "Disable",
        },
        diagnostics = {
            enable = true,
        },
    },
    pylsp = {
        plugins = {
            pycodestyle = {
                enabled = true,
                ignore = { "E501", "E231" },
                maxLineLength = 100,
            },
        },
    },
}

-- apply lsp configs and simplify nesting
for k, v in pairs(configs) do
    local name = k
    if v.rename ~= nil then
        name = v.rename
        v.rename = nil
    end

    local opts = { settings = { [name] = v } }
    vim.lsp.config(k, opts)
end

-- set lsp keymaps on attach
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        -- check if we already set keymaps for this buffer
        if vim.b[ev.buf].is_lsp_km_set then
            return
        end
        vim.b[ev.buf].is_lsp_km_set = true

        vim.lsp.inlay_hint.enable()
        U.set_config_keymap("lsp", {
            noremap = true,
            buffer = ev.buf,
        })
    end,
})

return {
    {
        "folke/lazydev.nvim",
        dependencies = { "Bilal2453/luvit-meta" },
        event = "LazyProject:nvim",
        opts = {
            library = { "luvit-meta/library" },
        },
    },
}
