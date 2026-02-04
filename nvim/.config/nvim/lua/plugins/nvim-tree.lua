return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- Iconos opcionales
  config = function()
    require("nvim-tree").setup()
    
    -- Tu atajo específico para este plugin va aquí
    vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true })
  end
}
