-- 1. DEFINICIONES GLOBALES (ANTES DE NADA)
-- Es vital que esto esté al principio para que los plugins lo detecten.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 2. BOOTSTRAP DE LAZY.NVIM
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

-- 3. CARGA DE PLUGINS
require("lazy").setup("plugins")

-- 4. CONFIGURACIONES BÁSICAS
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"
vim.opt.cursorline = true
vim.opt.conceallevel = 2

-- 5. ATAJOS GENERALES
vim.keymap.set("n", "<leader>w", ":w<CR>", { silent = true })
vim.keymap.set("n", "<leader>q", ":q<CR>", { silent = true })
