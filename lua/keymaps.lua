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
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'typst',
  group = vim.api.nvim_create_augroup('typst_keys', { clear = true }),
  callback = function()
    -- Helper function for cleaner mapping syntax
    local function buf_map(mode, lhs, rhs)
      vim.keymap.set(mode, lhs, rhs, { buffer = true, silent = true })
    end

    -- =========================================================
    -- 1. TYPST WATCHER TOGGLE (With Error Reporting)
    -- =========================================================
    buf_map('n', '<leader>TT', function()
      if vim.b.typst_job_id then
        vim.fn.jobstop(vim.b.typst_job_id)
        vim.b.typst_job_id = nil
        vim.cmd 'cclose'
        vim.notify('Typst Watcher Stopped', vim.log.levels.INFO)
      else
        local file = vim.fn.expand '%'
        local script_path = vim.fn.expand 'typst-do.sh'
        vim.cmd 'write'

        vim.b.typst_job_id = vim.fn.jobstart({ script_path, file }, {
          on_stderr = function(_, data)
            if not data then
              return
            end

            local errors = {}
            local has_real_error = false

            for _, line in ipairs(data) do
              if line ~= '' then
                -- Typst errors usually contain "error" or "warning"
                if line:lower():find 'error' or line:lower():find 'warning' then
                  has_real_error = true
                end
                table.insert(errors, line)
              end
            end

            if has_real_error then
              vim.fn.setqflist({}, 'r', { title = 'Typst Errors', lines = errors })
              vim.cmd 'copen 6'
              vim.cmd 'wincmd p' -- Keep focus on your code
            elseif #errors > 0 then
              -- If there's output but no "error" word, it's likely a success message
              -- We clear the list and close the window
              vim.fn.setqflist({}, 'r', { title = 'Typst Errors', lines = {} })
              vim.cmd 'cclose'
            end
          end,
          on_exit = function()
            vim.b.typst_job_id = nil
          end,
        })

        vim.notify('Typst Watcher Started', vim.log.levels.INFO)
      end
    end)
    -- =========================================================
    -- 2. DOCUMENT STRUCTURE
    -- =========================================================
    -- Table of Contents (Outline)
    buf_map('n', '<leader>tT', 'i#outline(title: "Contents", indent: auto)<Enter><Enter><++><Esc>2ki')

    -- Metadata (Title/Author)
    buf_map('n', '<leader>td', 'i#set document(title: "<++>", author: "<++>")<Enter>#set page(paper: "a4")<Enter><Enter><++><Esc>3kgf"a')

    -- Headings
    buf_map('n', '<leader>t1', 'i=<Space><Enter><Enter><++><Esc>2kA')
    buf_map('n', '<leader>t2', 'i==<Space><Enter><Enter><++><Esc>2kA')
    buf_map('n', '<leader>t3', 'i===<Space><Enter><Enter><++><Esc>2kA')

    -- =========================================================
    -- 3. LISTS & TABLES
    -- =========================================================
    -- Numbered List
    buf_map('n', '<leader>tn', 'i+ <++><Enter>+ <++><Esc>ki')

    -- Table (Simple 2x2 setup)
    buf_map(
      'n',
      '<leader>tt',
      'i#table(<Enter>columns: (1fr, 1fr),<Enter>inset: 10pt,<Enter>align: horizon,<Enter>[*Header 1*], [*Header 2*],<Enter>[<++>], [<++>],<Enter>)<Esc>ki'
    )

    -- =========================================================
    -- 4. FORMATTING & MATH
    -- =========================================================
    -- Text Styles
    buf_map('n', '<leader>ti', 'i_<++>_<Esc>F_i') -- Italics
    buf_map('n', '<leader>tb', 'i*<++>*<Esc>F*i') -- Bold

    -- Links
    buf_map('n', '<leader>tl', 'i#link("<++>")[<++>]<Esc>F"hi')

    -- Images
    buf_map('n', '<leader>tg', 'i#figure(<Enter>image("<++>", width: 80%),<Enter>caption: [<++>],<Enter>)<Esc>2kf"a')

    -- Math
    buf_map('n', '<leader>tm', 'i$<++>$<Esc>F$i') -- Inline Math
    buf_map('n', '<leader>tM', 'i$ <++> $<Esc>F<space>i') -- Block Math

    -- Code Blocks
    buf_map('n', '<leader>tc', 'i```<Enter><++><Enter>```<Esc>ka')

    -- =========================================================
    -- 5. NAVIGATION (Placeholder Jumps)
    -- =========================================================
    buf_map('i', ';s', '<++>')
    buf_map('i', '<Space><Space>', '<Esc>/<++><Enter>"_c4l')
    buf_map('n', '<Space><Space>', '/<++><Enter>"_c4l')
  end,
})
