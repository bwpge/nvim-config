# nvim-config

My basic nvim configuration.

## Overview

This config is quite basic, focusing on mostly theme and quality of life plugins (`auto-pairs`, `gitsigns`, etc.). [`lazy.nvim`](https://github.com/folke/lazy.nvim) is used to manage plugins, and the bulk of setup is done in `lua/user/setup.lua`.

## Usage

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
