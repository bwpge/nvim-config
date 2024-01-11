return {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        local onedark = require("onedark")
        if require("user.theme").name == "onedark" then
            onedark.setup({})
            onedark.load()
        end
    end,
}
