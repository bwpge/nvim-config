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

**Example `customize.json`:**

```jsonc
{
  "theme": "catppuccin",
  "disabled": ["foo/bar"],
  "find_command": ["rg", "--files", "--color", "never", "-uu"]
}
```

The following themes (and associated variants) are supported in `customize.lua`:

- Catppuccin ([`catppuccin/nvim`](https://github.com/catppuccin/nvim))
- Dracula ([`Mofiqul/dracula.nvim`](https://github.com/Mofiqul/dracula.nvim))
- Gruvbox ([`ellisonleao/gruvbox.nvim`](https://github.com/ellisonleao/gruvbox.nvim))
- Kanagawa ([`rebelot/kanagawa.nvim`](https://github.com/rebelot/kanagawa.nvim))
- OneDark ([`navarasu/onedark.nvim`](https://github.com/navarasu/onedark.nvim))
- Rosé Pine ([`rose-pine/neovim`](https://github.com/rose-pine/neovim))
- Tokyo Night ([`folke/tokyonight.nvim`](https://github.com/folke/tokyonight.nvim))
