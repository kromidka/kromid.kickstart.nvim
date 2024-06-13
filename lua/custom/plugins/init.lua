-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {

  -- File Explorer in Vim Ctrl+f
  {
    'nvim-telescope/telescope-file-browser.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
  },
  'jvgrootveld/telescope-zoxide',
  -- Quick word search under cursor alt+p and alt+n
  'RRethy/vim-illuminate',
  'Pocco81/auto-save.nvim',
  'PProvost/vim-ps1', -- beter ps1
  --'vim-airline/vim-airline',
  --'vim-airline/vim-airline-themes',
  'junegunn/goyo.vim', -- Beautifle for text
  'plasticboy/vim-markdown', -- better markdown
  'editorconfig/editorconfig-vim', -- beter conf
  'xiyaowong/transparent.nvim', -- makes nvim transparent
  'lunarvim/synthwave84.nvim',
}
