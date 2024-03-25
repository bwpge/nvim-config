local utils = require("user.utils")

local function attached_lsp()
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
    if not clients or #clients == 0 then
        return ""
    end

    local t = {}
    for _, c in ipairs(clients) do
        table.insert(t, c.name)
    end
    return "  " .. table.concat(t, ", ")
end

return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        lazy = false,
        opts = utils.merge_custom_opts("lualine", {
            options = {
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
                disabled_filetypes = { "packer", "NVimTree", "neo-tree" },
            },
            sections = {
                lualine_b = {
                    { "branch", icon = "" },
                    "diagnostics",
                },
                lualine_c = {
                    "filename",
                },
                lualine_x = { attached_lsp, "filetype" },
                lualine_y = { "encoding", "fileformat", "progress" },
                lualine_z = { "location" },
            },
            extensions = { "lazy" },
        }),
    },
}
