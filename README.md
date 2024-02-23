# telescope-cmdline-word.nvim

This is a simple plugin that allows you to pick words from the buffer to insert
on the command line (for substitute and global).

![telescope-cmdline-word.nvim](https://i.imgur.com/zHcwczY.gif)

## Installation

### Lazy

```lua
return {
  "otavioschwanck/telescope-cmdline-word.nvim",
  opts = {
    add_mappings = true, -- add <tab> mapping automatically
  }
}
```

### Packer

```lua
use { 'otavioschwanck/telescope-cmdline-word.nvim', config = function()
  require('telescope-cmdline-word').setup({
    add_mappings = true, -- add <tab> mapping automatically
  })
end }
```

if you don't want to add <tab> mapping automatically, you can disable it with `add_mappings = false` and setting the map manually:

```lua
vim.keymap.set("c", "<tab>", require("telescope-cmdline-word.picker").find_word, { silent = true, noremap = true })
```


## Usage

Just press tab when on substitute (%s/) or global (g/).

## Advanced Setup

```lua
{
  find_word_function = function() ... end, -- function that return all words from buffer.  You can pass any other function that return a list of strings.
  picker_options = {}, -- options for the telescope picker.
  wildchar_new_map = "<C-t>", -- this plugin needs to remap wildchar to another key to use on tab.
  wildchar_map = "<Tab>", -- key to be mapped to toggle the window.
  enabled_regexp = {}, -- see at lua/telescope-cmdline-word/init.lua:8 for examples.  This is an array of regexp for what else commands should be enabled to use the word finder.
  dont_use_ivy_theme = false, -- by default, this plugin use ivy theme.
}
```

# Tips

This plugin works well with [search-replace.nvim](https://github.com/roobert/search-replace.nvim)

# Do you like my work? Please, buy me a coffee

https://www.buymeacoffee.com/otavioschwanck
