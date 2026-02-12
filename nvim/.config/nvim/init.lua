-- 1. GLOBAL DEFINITIONS (BEFORE ANYTHING ELSE)
-- It is vital that this is at the very top so plugins detect it.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 2. LAZY.NVIM BOOTSTRAP
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.loop or vim).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 3. LOAD PLUGINS
require("lazy").setup("plugins")

-- 4. BASIC CONFIGURATIONS
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"
vim.opt.cursorline = true
vim.opt.conceallevel = 2

-- 5. GENERAL KEYMAPS
vim.keymap.set("n", "<leader>w", ":w<CR>", { silent = true })
vim.keymap.set("n", "<leader>q", ":q<CR>", { silent = true })
