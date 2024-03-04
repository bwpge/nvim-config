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

The gitignored file `lua/user/customize.lua` can be created to change minor settings without leaving the repository in a dirty state.

**Example `customize.lua`:**

```lua
local M = {}

-- change the default theme
M.theme = "catppuccin"

-- disable plugins without modifying specs
M.disabled = {
    "foo/bar",
}

return M
```

The following themes (and associated variants) are supported in `customize.lua`:

- Catppuccin ([`catppuccin/nvim`](https://github.com/catppuccin/nvim))
- Dracula ([`Mofiqul/dracula.nvim`](https://github.com/Mofiqul/dracula.nvim))
- Gruvbox ([`ellisonleao/gruvbox.nvim`](https://github.com/ellisonleao/gruvbox.nvim))
- OneDark ([`navarasu/onedark.nvim`](https://github.com/navarasu/onedark.nvim))
- Rosé Pine ([`rose-pine/neovim`](https://github.com/rose-pine/neovim))
- Tokyo Night ([`folke/tokyonight.nvim`](https://github.com/folke/tokyonight.nvim))
