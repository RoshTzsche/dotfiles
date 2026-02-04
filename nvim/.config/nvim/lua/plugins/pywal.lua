return {
  "AlphaTechnolog/pywal.nvim",
  name = "pywal",
  priority = 1000, -- Cargar esto primero para evitar parpadeos
  config = function()
    local pywal = require("pywal")
    pywal.setup()
    
    -- Activar el tema
    vim.cmd("colorscheme pywal")
    
    -- Ajustes de Transparencia (Migrados desde tu init.lua)
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
  end,
}
