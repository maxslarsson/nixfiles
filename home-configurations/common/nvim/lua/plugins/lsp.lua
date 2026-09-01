-- LSP configuration

-- lazydev configures the Lua LSP for editing your Neovim config
vim.pack.add { 'https://github.com/folke/lazydev.nvim' }
require('lazydev').setup {
  library = {
    -- Load luvit types when the `vim.uv` word is found
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
  },
}

-- Useful status updates for LSP
vim.pack.add { 'https://github.com/j-hui/fidget.nvim' }
require('fidget').setup {}

-- nvim-lspconfig supplies the per-server default configs consumed by vim.lsp.config
vim.pack.add { 'https://github.com/neovim/nvim-lspconfig' }

-- This runs when an LSP attaches to a particular buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    -- Rename the variable under your cursor
    map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

    -- Execute a code action
    map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

    -- Goto Declaration (e.g. in C this jumps to the header)
    map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

    -- Highlight references of the word under the cursor while it rests there
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method('textDocument/documentHighlight', event.buf) then
      local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
        end,
      })
    end

    -- Toggle inlay hints if the server supports them
    if client and client:supports_method('textDocument/inlayHint', event.buf) then
      map('<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
      end, '[T]oggle Inlay [H]ints')
    end
  end,
})

-- Language servers. Completion capabilities are auto-registered by blink.cmp.
---@type table<string, vim.lsp.Config>
local servers = {
  texlab = {},
  zls = {},
  ocamllsp = {},
  clangd = {},
  cmake = {},
  gopls = {},
  basedpyright = {},
  rust_analyzer = {},
  vtsls = {},
  lua_ls = {},
  nixd = {
    settings = {
      nixd = {
        nixpkgs = {
          expr = 'import (builtins.getFlake(toString ./.)).inputs.nixpkgs { }',
        },
        formatting = {
          command = { 'nixfmt' },
        },
        options = {
          -- nixos = {
          --   expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.k-on.options',
          -- },
          nix_darwin = {
            expr = '(builtins.getFlake ("git+file://" + toString ./.)).darwinConfigurations."Maxs-MacBook-Pro".options',
          },
          home_manager = {
            expr = '(builtins.getFlake ("git+file://" + toString ./.)).homeConfigurations."maxlarsson".options',
          },
        },
      },
    },
  },
}

-- Apply each server's config and enable it
for name, config in pairs(servers) do
  vim.lsp.config(name, config)
  vim.lsp.enable(name)
end
