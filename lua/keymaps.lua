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
    keymap('n', '<leader>mT', ':InsertToc<Enter>')
    keymap('n', '<leader>m1', 'i#<Space><Space><Enter><Enter><++><esc>2ki')
    keymap('n', '<leader>m2', 'i##<Space><Enter><Enter><++><Esc>2kA')
    keymap('n', '<leader>m3', 'i###<Space><Enter><Enter><++><Enter><Enter><++><Esc>4kA')
    keymap('n', '<leader>mi', 'i**<space><++><Esc>5hi')
    keymap('n', '<leader>mb', 'i****<Space><++><Esc>6hi')
    keymap('n', '<leader>mpe', 'i----<Enter><Enter>')
    keymap('n', '<leader>mm', 'i![]()<Space><Space><Enter><++><Esc>/(<Enter>li')
    keymap('i', ';s', '<++>')
    keymap('i', '<Space><Space>', '<Esc>/<++><Enter>"_c4l')
    keymap('n', '<Space><Space>', '/<++><Enter>"_c4l')
  end,
})

--vim.keymap.set('n', '<leader>TT', function()
--  -- 1. Get the current file name
--  local file = vim.fn.expand '%'
--
--  -- 2. Optional: Save the file before running (so the watcher picks up current state)
--  vim.cmd 'write'
--
--  -- 3. Open a vertical split and run the script inside a terminal
--  -- Change 'typst-watch' to the full path if you didn't move it to /bin
--  vim.cmd('vsplit | terminal ~/typst-do.sh ' .. file)
--
--  -- 4. (Optional) Switch focus back to the code window immediately
--  -- vim.cmd("wincmd p")
--end, { desc = '[T]ypst [T]erminal Watch' })

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'typst',
  callback = function()
    vim.keymap.set('n', '<leader>TT', function()
      -- Check if a job is already running for this buffer
      if vim.b.typst_job_id then
        -- STOP the watcher
        vim.fn.jobstop(vim.b.typst_job_id)
        vim.b.typst_job_id = nil
        vim.notify('Typst Watcher Stopped', vim.log.levels.INFO)
      else
        -- START the watcher
        local file = vim.fn.expand '%'
        local script_path = vim.fn.expand '~/.config/nvim/lua/typst-do.sh'
        vim.cmd 'write' -- Save before starting

        -- Run the script in the background
        -- Ensure 'typst-watch' is in your PATH, or use the absolute path like '/home/user/bin/typst-watch'
        vim.b.typst_job_id = vim.fn.jobstart({ script_path, file }, {
          detach = true, -- keeps it running if you switch buffers
          on_exit = function()
            -- Reset the ID if the script exits on its own (e.g., error)
            vim.b.typst_job_id = nil
          end,
          -- Optional: output error messages to Neovim's message area
          on_stderr = function(_, data)
            if data and #data > 1 then
              -- formatting to avoid empty lines
              local msg = table.concat(data, '\n')
              if msg ~= '' then
                vim.notify('Typst Error: ' .. msg, vim.log.levels.ERROR)
              end
            end
          end,
        })

        vim.notify('Typst Watcher Started', vim.log.levels.INFO)
      end
    end, { buffer = true, desc = 'Toggle Typst Watcher' })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'typst',
  group = vim.api.nvim_create_augroup('typst_keys', { clear = true }),
  callback = function()
    local function buf_map(mode, lhs, rhs)
      vim.keymap.set(mode, lhs, rhs, { buffer = true, silent = true })
    end

    -- Headings (Typst uses = instead of #)
    buf_map('n', '<leader>t1', 'i=<Space><Enter><Enter><++><Esc>2kA')
    buf_map('n', '<leader>t2', 'i==<Space><Enter><Enter><++><Esc>2kA')
    buf_map('n', '<leader>t3', 'i===<Space><Enter><Enter><++><Esc>2kA')

    -- Text Formatting
    buf_map('n', '<leader>ti', 'i_<++>_<Esc>F_i') -- Italics
    buf_map('n', '<leader>tb', 'i*<++>*<Esc>F*i') -- Bold
    buf_map('n', '<leader>tm', 'i$<++>$<Esc>F$i') -- Inline Math
    buf_map('n', '<leader>tl', 'i#link("<++>")[<++>]<Esc>F"hi') -- Link

    buf_map('n', '<leader>tT', 'i#outline(title: "Contents", indent: auto)<Enter><Enter><++><Esc>2ki')
    -- New: Useful Typst Specifics

    -- Metadata/Frontmatter Block
    buf_map('n', '<leader>td', 'i#set document(title: "<++>", author: "<++>")<Enter>#set page(paper: "a4")<Enter><Enter><++><Esc>3kgf"a')

    -- Block Math (Centered)
    buf_map('n', '<leader>tM', 'i$ <++> $<Esc>F<space>i')

    -- Image Block
    buf_map('n', '<leader>tg', 'i#figure(<Enter>image("<++>", width: 80%),<Enter>caption: [<++>],<Enter>)<Esc>2kf"a')

    -- Code Block
    buf_map('n', '<leader>tc', 'i```<Enter><++><Enter>```<Esc>ka')

    -- Navigation (Your <++> jumps)
    buf_map('i', ';s', '<++>')
    buf_map('i', '<Space><Space>', '<Esc>/<++><Enter>"_c4l')
    buf_map('n', '<Space><Space>', '/<++><Enter>"_c4l')
  end,
})
