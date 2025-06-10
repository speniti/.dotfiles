vim.cmd("let g:netrw_liststyle = 3")

vim.opt.relativenumber = true
vim.opt.number = true
vim.o.timeoutlen = 250

-- tabs & indentation
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = false
vim.opt.autoindent = true

vim.opt.wrap = false

-- search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.cursorline = true

vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"

-- backspace
vim.opt.backspace = "indent,eol,start"

-- clipboard
vim.opt.clipboard:append("unnamedplus")

-- split windows
vim.opt.splitright = true
vim.opt.splitbelow = true
