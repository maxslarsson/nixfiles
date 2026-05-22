-- Autoformatting with conform.nvim
vim.pack.add { 'https://github.com/stevearc/conform.nvim' }

require('conform').setup {
  notify_on_error = false,
  formatters_by_ft = {
    lua = { 'stylua' },
    c = { 'clang_format' },
    cpp = { 'clang_format' },
    python = { 'isort', 'black' },
    rust = { 'rustfmt' },
    nix = { 'nixfmt' },
    ocaml = { 'ocamlformat' },
  },
  -- Format-on-save is intentionally disabled; format manually with <leader>f.
  -- To enable it later, add a `format_on_save` function here.
}

vim.keymap.set('', '<leader>f', function()
  local bufnr = vim.api.nvim_get_current_buf()
  require('conform').format({ async = true, lsp_format = 'fallback' }, function(err)
    -- The formatter may have rewritten the indentation (e.g. 4-space to
    -- 2-space), leaving the load-time guess stale. Re-detect so further
    -- edits use the formatted file's actual style.
    if not err then
      require('guess-indent').set_from_buffer(bufnr, true, true)
    end
  end)
end, { desc = '[F]ormat buffer' })
