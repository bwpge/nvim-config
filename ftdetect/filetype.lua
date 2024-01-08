vim.filetype.add({
    filename = {
        ["env"] = "sh",
        ["tsconfig.json"] = "jsonc",
    },
    pattern = {
        [".*.gitconfig..*"] = "gitconfig",
        [".*.env..*"] = "sh",
    }
})
