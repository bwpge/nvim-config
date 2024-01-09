# nvim-config

My nvim configuration.

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

## Usage

### Theme

The theme name is defined in `user.theme`, which controls the configuration logic to pick which colorscheme to use (as well as configure some additional colors for other plugins).

Supported themes:

- [`Mofiqul/dracula.nvim`](https://github.com/Mofiqul/dracula.nvim)
- [`navarasu/onedark.nvim`](https://github.com/navarasu/onedark.nvim)
