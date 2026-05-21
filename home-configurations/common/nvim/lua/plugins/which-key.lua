-- Shows pending keybinds as you type a leader sequence
vim.pack.add { 'https://github.com/folke/which-key.nvim' }

require('which-key').setup {
  -- Delay between pressing a key and opening which-key (milliseconds)
  delay = 500,
  icons = {
    mappings = vim.g.have_nerd_font,
  },
  -- Document existing key chains
  spec = {
    { '<leader>s', group = '[S]earch' },
    { '<leader>t', group = '[T]oggle' },
    { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
    { 'gr', group = 'LSP Actions' },
  },
}
