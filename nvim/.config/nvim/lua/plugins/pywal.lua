return {
  "AlphaTechnolog/pywal.nvim",
  name = "pywal",
  priority = 1000,
  config = function()
    local pywal = require("pywal")
    pywal.setup()
    
    vim.cmd("colorscheme pywal")
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
  end,
}
