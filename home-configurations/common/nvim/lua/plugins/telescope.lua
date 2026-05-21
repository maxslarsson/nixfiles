-- Fuzzy finder (files, lsp, etc)

local telescope_plugins = {
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-telescope/telescope.nvim',
  'https://github.com/nvim-telescope/telescope-ui-select.nvim',
}
-- telescope-fzf-native needs `make`; build is run by the PackChanged hook in init.lua
if vim.fn.executable 'make' == 1 then
  table.insert(telescope_plugins, 'https://github.com/nvim-telescope/telescope-fzf-native.nvim')
end
vim.pack.add(telescope_plugins)

require('telescope').setup {
  extensions = {
    ['ui-select'] = {
      require('telescope.themes').get_dropdown(),
    },
  },
}

-- Enable Telescope extensions if they are installed
pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'ui-select')

local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set('n', '<leader>sc', builtin.commands, { desc = '[S]earch [C]ommands' })
vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

vim.keymap.set('n', '<leader>/', function()
  builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>s/', function()
  builtin.live_grep {
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  }
end, { desc = '[S]earch [/] in Open Files' })

vim.keymap.set('n', '<leader>sn', function()
  builtin.find_files { cwd = vim.fn.stdpath 'config' }
end, { desc = '[S]earch [N]eovim files' })

-- Telescope-backed LSP pickers, set when an LSP attaches to a buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
  callback = function(event)
    local buf = event.buf
    vim.keymap.set('n', 'grr', builtin.lsp_references, { buffer = buf, desc = 'LSP: [G]oto [R]eferences' })
    vim.keymap.set('n', 'gri', builtin.lsp_implementations, { buffer = buf, desc = 'LSP: [G]oto [I]mplementation' })
    vim.keymap.set('n', 'grd', builtin.lsp_definitions, { buffer = buf, desc = 'LSP: [G]oto [D]efinition' })
    vim.keymap.set('n', 'grt', builtin.lsp_type_definitions, { buffer = buf, desc = 'LSP: [G]oto [T]ype Definition' })
    vim.keymap.set('n', 'gO', builtin.lsp_document_symbols, { buffer = buf, desc = 'LSP: Open Document Symbols' })
    vim.keymap.set('n', 'gW', builtin.lsp_dynamic_workspace_symbols, { buffer = buf, desc = 'LSP: Open Workspace Symbols' })
  end,
})
