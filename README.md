# MLTS - My Lovely Theme Selector

A Neovim plugin for browsing and selecting themes with live preview and persistent selection.

[![asciicast](https://asciinema.org/a/6MQeOrd7BvgkvcC73kKrTRbCG.svg)](https://asciinema.org/a/6MQeOrd7BvgkvcC73kKrTRbCG)

## Features

- **Interactive theme browser** with bottom split UI
- **Live preview** - see themes as you navigate
- **Persistent selection** - your choice is saved across sessions
- **Auto-apply** - automatically loads your selected theme on startup
- **Simple navigation** - use j/k to browse, Enter to select
- **Works with any colorscheme** - not just MLTB themes

## Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  'enheit/mlts',
  config = function()
    require('mlts').setup()
  end
}
```

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  'enheit/mlts',
  config = function()
    require('mlts').setup()
  end
}
```

## Usage

### Open Theme Selector

Run the command:

```vim
:MLTSSelect
```

This will:
1. Scan your themes directory for available themes
2. Open an interactive menu in a bottom split
3. Show live preview as you navigate

### Navigation

Once the menu opens:

- **`j`** - Move down (next theme)
- **`k`** - Move up (previous theme)
- **`Enter`** - Select theme and save it permanently
- **`q`** - Close without saving selection

### How It Works

- **Preview**: As you navigate with j/k, themes are temporarily applied
- **Selection**: Pressing Enter permanently saves and applies the theme
- **Auto-apply**: On next Neovim startup, your selected theme loads automatically
- **Close without saving**: Press `q` to exit - no changes are made

## Configuration

```lua
require('mlts').setup({
  -- Directory where themes are stored
  themes_dir = vim.fn.stdpath('config') .. '/themes',

  -- Auto-apply saved theme on startup
  auto_apply = true,
})
```

## Theme Location

By default, MLTS scans for themes in:

```
~/.config/nvim/themes/
```

This is the same directory where [MLTB](https://github.com/enheit/mltb) saves generated themes.

## Persistence

Your theme selection is saved to:

```
~/.local/share/nvim/mlts_selection.txt
```

This file contains just the theme name. On startup, if `auto_apply` is enabled, MLTS will automatically load this theme.

## Example Workflow

### With MLTB

1. Generate themes with `:MLTBStart` (from MLTB plugin)
2. Save multiple themes you like
3. Use `:MLTSSelect` to browse and pick your favorite
4. Selection persists - theme loads automatically on restart

### With Any Colorscheme

1. Place colorscheme `.lua` files in `~/.config/nvim/themes/`
2. Run `:MLTSSelect`
3. Browse and select

## Companion Plugin

MLTS works great with [MLTB](https://github.com/enheit/mltb) (My Lovely Theme Builder):

- **MLTB**: Generate random themes using Tailwind colors and color theory
- **MLTS**: Browse and select from your generated themes

Together, they provide a complete theme creation and selection workflow!

## License

MIT
