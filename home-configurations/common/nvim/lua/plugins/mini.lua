-- Collection of small independent plugins/modules
vim.pack.add { 'https://github.com/nvim-mini/mini.nvim' }

-- Better Around/Inside textobjects
--  - va)  - [V]isually select [A]round [)]paren
--  - yinq - [Y]ank [I]nside [N]ext [Q]uote
--  - ci'  - [C]hange [I]nside [']quote
require('mini.ai').setup {
  n_lines = 500,
  -- Avoid conflicts with treesitter incremental selection on Neovim >= 0.12
  mappings = {
    around_next = 'aa',
    inside_next = 'ii',
  },
}

-- Add/delete/replace surroundings (brackets, quotes, etc.)
require('mini.surround').setup()

-- Simple and easy statusline
local statusline = require 'mini.statusline'
statusline.setup { use_icons = vim.g.have_nerd_font }

-- Show cursor location as LINE:COLUMN
statusline.section_location = function()
  return '%2l:%-2v'
end
