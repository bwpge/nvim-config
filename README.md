# nvim-config

My Neovim configuration.

## Overview

This config aims to be simple to use and extensible. [`lazy.nvim`](https://github.com/folke/lazy.nvim) is used to manage plugins, and configuration is done through the `user.plugins` module.

## Installation

Clone this repo to the nvim config directory (see [`:h standard-path`](https://neovim.io/doc/user/starting.html#standard-path) for more information). The nvim config path can be viewed with the following command:

```sh
nvim --clean --headless -n -c 'echo stdpath("config")' +q
```

**Windows (PowerShell):**

```powershell
git clone git@github.com:bwpge/nvim-config.git $env:LOCALAPPDATA/nvim
```

**Linux/macOS:**

```sh
git clone git@github.com:bwpge/nvim-config.git ~/.config/nvim
```

Be sure to remove any previous `data` directory, e.g. `stdpath("data")`, to start with a clean install.

## Customize

A `customize.json` can be created in the config root to change minor settings without leaving the repository in a dirty state.

> [!IMPORTANT]
>
> Comments are not allowed in this file.

Example:

```jsonc
{
  // change default theme
  "theme": "catppuccin",
  // disable plugins without changing specs
  "disabled": ["foo/bar"],

  // some plugins can merge options from this file (all themes are supported)
  "catppuccin": {
    "flavour": "mocha",
  },
  "kanagawa": {
    "theme": "wave"
  },
  "telescope": {
    "pickers": {
      "find_files": {
        "hidden": true,
        "find_command": ["rg", "--files", "--color=never"]
      }
    }
  }
}
```

The following keys will customize plugin options in `customize.lua`:

- All themes (`catppuccin`, `dracula`, etc.)
- `lualine`
- `neo-tree`
- `telescope`
- `todo-comments`
- `toggleterm`
- `treesitter`
