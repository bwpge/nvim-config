vim.filetype.add({
    filename = {
        ["env"] = "sh",
        ["go.mod"] = "gomod",
        ["requirements.txt"] = "config",
        ["tsconfig.json"] = "jsonc",
    },
    extension = {
        ["zsh-theme"] = "zsh",
    },
    pattern = {
        [".*.gitconfig"] = "gitconfig",
        [".gitconfig[-_.].*"] = "gitconfig",
        [".*.env..*"] = "sh",
        [".*[-_]requirements.txt"] = "config",
        ["requirements[-_].*.txt"] = "config",
    },
})
