-- Shorten function name
local keymap = vim.keymap.set
-- Silent keymap option
local opts = { silent = true }

--Remap space as leader key
keymap('', '<Space>', '<Nop>', opts)
vim.g.mapleader = ' '

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
keymap('n', '<C-h>', '<C-w>h', opts)
keymap('n', '<C-j>', '<C-w>j', opts)
keymap('n', '<C-k>', '<C-w>k', opts)
keymap('n', '<C-l>', '<C-w>l', opts)

-- Resize with arrows
keymap('n', '<C-Up>', ':resize -2<CR>', opts)
keymap('n', '<C-Down>', ':resize +2<CR>', opts)
keymap('n', '<C-Left>', ':vertical resize -2<CR>', opts)
keymap('n', '<C-Right>', ':vertical resize +2<CR>', opts)

-- Navigate buffers
keymap('n', '<S-l>', ':bnext<CR>', opts)
keymap('n', '<S-h>', ':bprevious<CR>', opts)

-- Clear highlights
keymap('n', '<leader>h', '<cmd>nohlsearch<CR>', opts)

-- Close buffers
keymap('n', '<S-q>', '<cmd>Bdelete!<CR>', opts)

-- Better paste
keymap('v', 'p', '"_dP', opts)

-- Insert --
-- Press jj fast to enter
keymap('i', 'jj', '<ESC>', opts)

-- Visual --
-- Stay in indent mode
keymap('v', '<', '<gv', opts)
keymap('v', '>', '>gv', opts)

-- Plugins --
keymap('n', '<leader>a', ':Alpha<CR>', opts)
keymap('n', '<leader>cc', ':ClaudeCode<CR>', opts)

-- Comment
keymap('n', '<leader>/', "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>", opts)
keymap('x', '<leader>/', '<ESC><CMD>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>')

-- Custom
keymap('n', '<leader>p', '<cmd> PasteImage <CR>', opts)
keymap('n', '<leader>e', '$', opts)
keymap('n', 'S', '<cmd> %s//g', opts)
keymap('n', '<F5>', '<cmd> UndotreeToggle <CR> <cmd> UndotreeFocus <CR>', opts)
keymap('n', '<C-\\>', '<cmd> TZAtaraxis <CR>', opts)
keymap('n', '<Leader>1', '1gt<CR>', opts)
keymap('n', '<Leader>2', '2gt<CR>', opts)
keymap('n', '<Leader>3', '3gt<CR>', opts)
keymap('n', '<Leader>4', '4gt<CR>', opts)
keymap('n', '<Leader>5', '5gt<CR>', opts)
keymap('n', '<Leader>t', '<cmd> tabnew<CR>', opts)
keymap('n', '<Leader>c', '<cmd> tabclose<CR>', opts)

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  group = vim.api.nvim_create_augroup('md', { clear = true }),
  callback = function()
    vim.keymap.set('n', ';T', ':InsertToc<Enter>')
    vim.keymap.set('i', ';1', '#<Space><Space><Enter><Enter><++><esc>2ki')
    vim.keymap.set('i', ';2', '##<Space><Enter><Enter><++><Esc>2kA')
    vim.keymap.set('i', ';3', '###<Space><Enter><Enter><++><Enter><Enter><++><Esc>4kA')
    vim.keymap.set('i', ';i', '**<space><++><Esc>5hi')
    vim.keymap.set('i', ';b', '****<Space><++><Esc>6hi')
    vim.keymap.set('i', ';pe', '----<Enter><Enter>')
    vim.keymap.set('i', ';m', '![]()<Space><Space><Enter><++><Esc>/(<Enter>li')
    vim.keymap.set('i', ';s', '<++>')
    vim.keymap.set('i', '<Space><Space>', '<Esc>/<++><Enter>"_c4l')
    vim.keymap.set('n', '<Space><Space>', '<Esc>/<++><Enter>"_c4l')
  end,
})