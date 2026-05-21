-- Autoformatting with conform.nvim
vim.pack.add { 'https://github.com/stevearc/conform.nvim' }

require('conform').setup {
  notify_on_error = false,
  formatters_by_ft = {
    lua = { 'stylua' },
    python = { 'isort', 'black' },
    rust = { 'rustfmt' },
    nix = { 'nixfmt' },
    ocaml = { 'ocamlformat' },
  },
  -- Format-on-save is intentionally disabled; format manually with <leader>f.
  -- To enable it later, add a `format_on_save` function here.
}

vim.keymap.set('', '<leader>f', function()
  require('conform').format { async = true, lsp_format = 'fallback' }
end, { desc = '[F]ormat buffer' })
