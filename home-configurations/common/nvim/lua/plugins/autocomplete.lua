-- Autocompletion and snippets

-- Snippet engine
vim.pack.add {
  { src = 'https://github.com/L3MON4D3/LuaSnip', version = vim.version.range '2.*' },
}
require('luasnip').setup {}

-- friendly-snippets: a collection of premade snippets, loaded into LuaSnip
vim.pack.add { 'https://github.com/rafamadriz/friendly-snippets' }
require('luasnip.loaders.from_vscode').lazy_load()

-- Completion engine
vim.pack.add {
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range '1.*' },
}
require('blink.cmp').setup {
  keymap = { preset = 'default' },

  appearance = {
    nerd_font_variant = 'mono',
  },

  completion = {
    documentation = { auto_show = false, auto_show_delay_ms = 500 },
  },

  sources = {
    default = { 'lsp', 'path', 'snippets', 'lazydev' },
    providers = {
      lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
    },
  },

  snippets = { preset = 'luasnip' },

  -- Use the Lua fuzzy matcher (no prebuilt binary download)
  fuzzy = { implementation = 'lua' },

  -- Show a signature help window while typing function arguments
  signature = { enabled = true },
}
