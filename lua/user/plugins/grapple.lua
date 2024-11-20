local function grapple_toggle()
    local action = "Added"
    if require("grapple").exists() then
        action = "Removed"
    end

    ---@diagnostic disable-next-line: param-type-mismatch
    local ok, err = pcall(vim.cmd, "Grapple toggle")
    if ok then
        vim.notify(action .. " grapple tag: " .. vim.fn.expand("%:."))
        vim.schedule(vim.cmd.redrawstatus)
    else
        vim.notify("Failed to toggle grapple tag: " .. err, vim.log.levels.WARN)
    end
end

return {
    "cbochs/grapple.nvim",
    dependencies = {
        { "nvim-tree/nvim-web-devicons" },
    },
    command = "Grapple",
    keys = {
        { ";", "<cmd>Grapple toggle_tags<cr>", desc = "Grapple: Toggle tags menu" },
        { "<leader>;", grapple_toggle, desc = "Grapple: Toggle tag" },
        { "[g", "<cmd>Grapple cycle_tags prev<cr>", desc = "Grapple: Go to next tag" },
        { "]g", "<cmd>Grapple cycle_tags next<cr>", desc = "Grapple: Go to previous tag" },
    },
    opts = {
        scope = "git_branch",
        icons = true,
        quick_select = "123456789",
    },
    config = function(_, opts)
        require("grapple").setup(opts)
        require("telescope").load_extension("grapple")
    end,
}
