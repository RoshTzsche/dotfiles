return {
  "lervag/vimtex",
  lazy = false, -- VimTeX necesita cargarse al inicio para funcionar correctamente
  init = function()
    -- Configura Zathura como el visor de PDF por defecto
    vim.g.vimtex_view_method = "zathura"
    
    -- Usa latexmk como compilador continuo (recompila al guardar)
    vim.g.vimtex_compiler_method = "latexmk"
    
    -- Ocultar advertencias y mensajes innecesarios
    vim.g.vimtex_quickfix_mode = 0
    
    -- (Opcional) Si quieres replicar el comportamiento de Typst de usar <leader>t para ver el PDF
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "tex",
      callback = function()
        vim.keymap.set("n", "<leader>t", "<plug>(vimtex-view)", { buffer = true, desc = "Spawn Zathura (LaTeX)", silent = true })
      end,
    })
  end
}
