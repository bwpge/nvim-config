vim.filetype.add({
    filename = {
        ["env"] = "sh",
        ["tsconfig.json"] = "jsonc",
        ["requirements.txt"] = "config",
    },
    extension = {
        ["zsh-theme"] = "zsh",
    },
    pattern = {
        [".*.gitconfig"] = "gitconfig",
        [".gitconfig..*"] = "gitconfig",
        [".*.env..*"] = "sh",
        [".*[-_]requirements.txt"] = "config",
        ["requirements[-_].*.txt"] = "config",
    },
})
