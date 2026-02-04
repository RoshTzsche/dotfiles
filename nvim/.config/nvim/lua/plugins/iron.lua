return {
  "Vigemus/iron.nvim",
  -- Evento: Cárgalo cuando entres a un buffer, o usa "VeryLazy" si prefieres velocidad de arranque pura.
  event = "VeryLazy", 
  
  config = function()
    local iron = require("iron.core")
    local view = require("iron.view")
    local common = require("iron.fts.common")
    iron.setup({
      config = {
        -- REPL Definitions: Aquí defines qué binario ejecuta cada lenguaje.
        -- Python es vital para tus scripts de Pywal.
        repl_definition = {
          python = {
            command = { "python3" },
	    format = common.bracketed_paste_python,
	    block_dividers = {"# %%", "#%%"},
	    env = {PYTHON_BASIC_REPL = "1"}
          },
          sh = {
            command = {"zsh"} -- O bash, según tu shell en CachyOS
          }
        },
        -- Cómo se abre la ventana del REPL
        -- Usamos split vertical al 40% del ancho por tu pantalla 16:10
        repl_open_cmd = view.split.vertical.botright("40%"),
      },
      
      -- Configuración de brillo/resaltado al enviar código
      highlight = {
        italic = true
      },
      
      -- Ignorar ventanas flotantes para evitar conflictos con lazy.nvim o wofi
      ignore_blank_lines = true, 
    })

    -- TUS ATAJOS (Aquí es donde tú tomas el control)
    -- Iron tiene sus propios mapeos internos, pero es mejor definirlos via vim.keymap
    -- para consistencia con tu Leader Key.
    
    -- Mapeo para visualizar/ocultar el REPL
    vim.keymap.set('n', '<leader>rr', '<cmd>IronRepl<cr>', { desc = "REPL Toggle" })
    
    -- Mapeo para reiniciar el REPL (útil si Python se cuelga)
    vim.keymap.set('n', '<leader>rt', '<cmd>IronRestart<cr>', { desc = "REPL Restart" })
    
    -- Mapeo para enviar el archivo completo
    vim.keymap.set('n', '<leader>rf', function() iron.send_file() end, { desc = "REPL Send File" })

    -- NOTA: Para enviar líneas o selección visual, Iron requiere un operador.
    -- Configura esto abajo siguiendo la documentación.
    -- Mapeo para enviar movimientos. 
-- Al pulsar <leader>s, Vim esperará que le digas "qué" enviar (ej: <leader>sip envia el parrafo).
	vim.keymap.set("n", "<leader>s", function()
  		iron.run_motion("send_motion")
	end, { desc = "REPL Send Motion" })
-- Mapeo para enviar lo que tengas seleccionado visualmente
	vim.keymap.set("v", "<leader>s", function()
  		iron.visual_send()
	end, { desc = "REPL Visual Send" })
  end
}
