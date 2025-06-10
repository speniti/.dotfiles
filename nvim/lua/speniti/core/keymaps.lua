vim.g.mapleader = " "

vim.keymap.set('i', 'jj', '<ESC>', { desc = 'Exit insert mode with jj' })
vim.keymap.set('i', 'jk', '<ESC>', { desc = 'Exit insert mode with jk' })

vim.keymap.set('n', '<ESC>', '<cmd>nohl<CR>', { desc = 'Clear search highlights' })

vim.keymap.set('n', '<leader>+', '<C-a>', { desc = 'Increment number' })
vim.keymap.set('n', '<leader>-', '<C-w>', { desc = 'Decrement number' })

vim.keymap.set('n', '<leader>sv', '<C-w>v', { desc = 'Split window vertically' })
vim.keymap.set('n', '<leader>sh', '<C-w>s', { desc = 'Split window horizontally' })
vim.keymap.set('n', '<leader>se', '<C-w>=', { desc = 'Make splits equal size' })
vim.keymap.set('n', '<leader>sx', '<cmd>close<CR>', { desc = 'Close current split' })
