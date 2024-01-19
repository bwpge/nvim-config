vim.filetype.add({
    filename = {
        ["env"] = "sh",
        ["tsconfig.json"] = "jsonc",
    },
    extension = {
        ["zsh-theme"] = "zsh",
    },
    pattern = {
        [".*.gitconfig"] = "gitconfig",
        [".gitconfig..*"] = "gitconfig",
        [".*.env..*"] = "sh",
    },
})
