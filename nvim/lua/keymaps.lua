local map = vim.api.nvim_set_keymap
-- move window
map('n', '<Leader>j', '<C-w>j', { noremap = true, silent = true })
map('n', '<Leader>k', '<C-w>k', { noremap = true, silent = true })
map('n', '<Leader>l', '<C-w>l', { noremap = true, silent = true })
map('n', '<Leader>h', '<C-w>h', { noremap = true, silent = true })

-- split window
map('n', '<Leader>s', ':sp\n', { noremap = true })
map('n', '<Leader>v', ':vs\n', { noremap = true })

-- close window
map('n', '<Leader>w', ':w\n', { noremap = true })
map('n', '<Leader>q', ':q\n', { noremap = true })
map('n', '<Leader>wq', ':wq\n', { noremap = true })

-- open terminal
map('n', '<Leader>tt', ':terminal<CR>', { noremap = true })

-- exit terminal mode with Esc
map('t', '<Esc>', '<C-\\><C-n>', { noremap = true })

map('i', '<C-k>', '<Up>', {})
map('i', '<C-j>', '<Down>', {})
map('i', '<C-h>', '<Left>', {})
map('i', '<C-l>', '<Right>', {})

-- jump to line start/end (Emacs-style; overrides Ctrl+a increment in normal mode)
map('n', '<C-a>', '^', { noremap = true })
map('n', '<C-e>', '$', { noremap = true })
map('i', '<C-a>', '<C-o>^', { noremap = true })
map('i', '<C-e>', '<C-o>$', { noremap = true })

-- show diagnostics
map('n', '<Leader>d', ':lua vim.diagnostic.open_float()<CR>', { noremap = true })

-- rebind embeded command
map('n', '<C-_>', 'gcc', { noremap = false })
map('v', '<C-_>', 'gc', { noremap = false })

-- copy current file path to clipboard
local function copy_path(modifier, label)
  return function()
    local path = vim.fn.expand(modifier)
    if path == "" then
      vim.notify("No file in current buffer", vim.log.levels.WARN)
      return
    end
    vim.fn.setreg("+", path)
    vim.notify("Copied " .. label .. ": " .. path)
  end
end
vim.keymap.set('n', '<Leader>yp', copy_path("%:.", "relative path"), { desc = "Copy relative file path" })
vim.keymap.set('n', '<Leader>yP', copy_path("%:p", "absolute path"), { desc = "Copy absolute file path" })
vim.keymap.set('n', '<Leader>yn', copy_path("%:t", "file name"), { desc = "Copy file name" })

-- save with Ctrl+s
map('n', '<C-s>', ':w<CR>', { noremap = true, silent = true })
map('i', '<C-s>', '<Cmd>w<CR>', { noremap = true, silent = true })
