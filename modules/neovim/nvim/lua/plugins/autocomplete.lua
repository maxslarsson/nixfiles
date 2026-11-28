-- Autocompletion; LSP snippets expand with the built-in vim.snippet

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
    default = { 'lsp', 'path', 'lazydev' },
    providers = {
      lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
    },
  },

  -- Use the Lua fuzzy matcher (no prebuilt binary download)
  fuzzy = { implementation = 'lua' },

  -- Show a signature help window while typing function arguments
  signature = { enabled = true },
}
