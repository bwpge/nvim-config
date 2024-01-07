# nvim-config

My basic nvim configuration.

## Overview

This config is quite basic, focusing on mostly theme and quality of life plugins (`auto-pairs`, `gitsigns`, etc.). [`lazy.nvim`](https://github.com/folke/lazy.nvim) is used to manage plugins, and the bulk of setup is done in `lua/user/setup.lua`.

## Usage

Clone this repo and copy the contents to the nvim config directory (platform dependent). The nvim config path can be viewed with the following command:

```sh
nvim --clean --headless -n -c "echo stdpath('config')" +q
```

Be sure to remove any previous `nvim-data` directory.
