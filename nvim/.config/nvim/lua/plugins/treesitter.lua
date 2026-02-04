return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPre", "BufNewFile" }, -- Carga lazy: solo cuando abras un archivo real
  config = function()
    local status_ok, configs = pcall(require, "nvim-treesitter.configs")
    if not status_ok then
      return
    end

    configs.setup({
      ensure_installed = { "c", "lua", "vim", "vimdoc", 
      "query", 
      "python", 
      "markdown", 
      "bash", 
      "json",
      "markdown_inline",
	"latex" },
      sync_install = false,
      highlight = {
        enable = true,
      },
      indent = { enable = true },
    })
  end,
}
