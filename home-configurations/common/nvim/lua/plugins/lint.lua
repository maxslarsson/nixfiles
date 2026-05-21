-- Linting via nvim-lint
vim.pack.add { 'https://github.com/mfussenegger/nvim-lint' }

local lint = require 'lint'

-- No linters configured yet. nvim-lint does NOT install linters — each linter
-- must be available on PATH (add it to Nix home.packages or a devshell).
-- Example:
--   lint.linters_by_ft = { markdown = { 'markdownlint' } }
lint.linters_by_ft = {}

-- Run the configured linters on these events
local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
  group = lint_augroup,
  callback = function()
    -- Only lint modifiable buffers to avoid noise (e.g. LSP hover popups)
    if vim.bo.modifiable then
      lint.try_lint()
    end
  end,
})
