return {
    {
        "hrsh7th/nvim-cmp",
        event = "VeryLazy",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "L3MON4D3/LuaSnip",
            "onsails/lspkind.nvim",
            "rafamadriz/friendly-snippets",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local cmp = require("cmp")
            local cmp_context = require("cmp.config.context")
            local lspkind = require("lspkind")
            local luasnip = require("luasnip")

            require("luasnip.loaders.from_vscode").lazy_load({})
            require("luasnip.loaders.from_vscode").lazy_load({
                paths = vim.fn.stdpath("config") .. "/snippets/",
            })

            ---Toggle nvim-cmp documentation window.
            local toggle_docs = function()
                if cmp.visible_docs() then
                    cmp.close_docs()
                else
                    cmp.open_docs()
                end
            end

            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                sources = {
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    -- avoid polluting autocomplete with buffer text unless we want it
                    {
                        name = "buffer",
                        entry_filter = function(entry, _)
                            return cmp_context.in_treesitter_capture("string")
                                or cmp.lsp.CompletionItemKind.Text ~= entry:get_kind()
                        end,
                    },
                },
                completion = {
                    completeopt = "menu,menuone,preview,noselect",
                },
                formatting = {
                    format = lspkind.cmp_format({
                        mode = "symbol",
                        ellipsis_char = "…",
                    }),
                },
                mapping = {
                    -- accept completion, must select first
                    ["<cr>"] = cmp.mapping(cmp.mapping.confirm({ select = false }), { "i", "c" }),
                    -- show completion menu
                    ["<C-.>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
                    -- close completion menu
                    ["<esc>"] = cmp.mapping(cmp.mapping.abort(), { "i" }),
                    -- alternate keymap for command mode
                    ["<C-e>"] = cmp.mapping(cmp.mapping.abort(), { "c" }),
                    ["<up>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
                    ["<down>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
                    -- documentation
                    ["<M-k>"] = cmp.mapping.scroll_docs(-1),
                    ["<M-j>"] = cmp.mapping.scroll_docs(1),
                    ["<M-K>"] = cmp.mapping.scroll_docs(-5),
                    ["<M-J>"] = cmp.mapping.scroll_docs(5),
                    ["<M-i>"] = toggle_docs,
                    -- use tab for auto-complete, snippets, etc. depending what is visible
                    ["<tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.confirm({ select = true })
                        elseif luasnip.expandable() then
                            luasnip.expand()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-tab>"] = cmp.mapping(function(fallback)
                        if luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                },
                window = {
                    documentation = cmp.config.window.bordered(),
                },
            })

            -- cancel snippet when mode changes
            -- see: https://github.com/L3MON4D3/LuaSnip/issues/258#issuecomment-1429989436
            vim.api.nvim_create_autocmd("ModeChanged", {
                pattern = "*",
                callback = function()
                    local old_mode = vim.v.event.old_mode
                    local new_mode = vim.v.event.new_mode
                    if
                        ((old_mode == "s" and new_mode == "n") or old_mode == "i")
                        and luasnip.session.current_nodes[vim.api.nvim_get_current_buf()]
                        and not luasnip.session.jump_active
                    then
                        luasnip.unlink_current()
                    end
                end,
            })
        end,
    },
}
