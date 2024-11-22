# cargo-appraiser.nvim

1. [downlaod](https://github.com/washanhanzi/cargo-appraiser/releases) and add the lsp to your path
2. lazy:

```lua
{
  'washanhanzi/cargo-appraiser.nvim',
  dependencies = {
     'neovim/nvim-lspconfig',
  },
  config = function()
    require('cargo-appraiser').setup()
  end
}
```

This is a really early version(works on my machine kind).

If you have any questions, please [open an issue](https://github.com/washanhanzi/cargo-appraiser.nvim/issues/new).