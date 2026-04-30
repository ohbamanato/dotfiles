vim.o.encoding = 'utf-8'
vim.o.number = true

vim.o.smartindent = true
vim.o.clipboard = "unnamedplus"
vim.o.list = true
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.wrap = false
vim.o.termguicolors = true
vim.o.wildmenu = true
vim.o.ruler = true
vim.o.smartcase = true
vim.o.showmatch = true

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.termguicolors = true

vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
