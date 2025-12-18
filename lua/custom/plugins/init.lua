-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  'scottmckendry/cyberdream.nvim',
  'lunarvim/synthwave84.nvim',
  'emacs-grammarly/lsp-grammarly',
  'mbbill/undotree',

  {
    'Pocco81/auto-save.nvim',
    config = function()
      require('auto-save').setup {
        -- your config goes here
        -- or just leave it empty :)
      }
    end,
  },

  'lambdalisue/suda.vim',

  --	{
  --		"numToStr/Comment.nvim",
  --		config = function()
  --			require("Comment").setup()
  --		end,
  --	},

  'ionide/Ionide-vim',

  {
    'goolord/alpha-nvim',
    -- dependencies = { 'echasnovski/mini.icons' },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local startify = require 'alpha.themes.startify'
      -- available: devicons, mini, default is mini
      startify.file_icons.provider = 'devicons'
      require('alpha').setup(startify.config)
    end,
  },
  --  {
  --    'tribela/transparent.nvim',
  --    event = 'VimEnter',
  --    config = true,
  --  },
  -- Set lualine as statusline
  'nvim-lualine/lualine.nvim',
  -- See `:help lualine.txt`
  opts = {
    options = {
      icons_enabled = false,
      theme = 'dracula',
      component_separators = '|',
      section_separators = '',
    },
  },

  'jvgrootveld/telescope-zoxide',
  'PProvost/vim-ps1', -- beter ps1
  'junegunn/goyo.vim', -- Beautifle for text
  'plasticboy/vim-markdown', -- better markdown
  'editorconfig/editorconfig-vim', -- beter conf
  'xiyaowong/transparent.nvim', -- makes nvim transparent
}
