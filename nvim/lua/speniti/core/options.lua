vim.cmd("let g:netrw_liststyle = 3")

vim.o.relativenumber = true
vim.o.number = true
vim.wrap = false
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8

-- tabs & indentation
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = false
vim.o.autoindent = true
vim.o.smartindent = true

-- search settings
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true

-- visual settings
vim.o.cursorline = true
vim.o.termguicolors = true
vim.o.signcolumn = "yes"
vim.o.colorcolumn = "120"
vim.o.cmdheight = 0
vim.o.list = true
vim.opt.listchars = { tab = "  ", trail = "·", nbsp = "␣" }
vim.o.inccommand = "split"

-- file handling
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false
vim.o.undofile = true
vim.o.undodir = vim.fn.expand("~/.vim/undodir")
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.ttimeoutlen = 0
vim.o.autoread = true
vim.o.autowrite = false

-- behavior settings
vim.o.hidden = true
vim.o.errorbells = false
vim.o.backspace = "indent,eol,start"
vim.o.autochdir = false
vim.opt.iskeyword:append("-")
vim.opt.path:append("**")
vim.o.selection = "exclusive"
vim.o.mouse = "a"
vim.o.modifiable = true
vim.o.encoding = "UTF-8"
vim.o.confirm = true

vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

-- split behavior
vim.o.splitright = true
vim.o.splitbelow = true
