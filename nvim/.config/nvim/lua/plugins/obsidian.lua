return {
  "epwalsh/obsidian.nvim",
  version = "*",  -- Recomendado para estabilidad, usa la última release semver
  lazy = true,
  ft = "markdown", -- Solo carga este plugin cuando abras un archivo Markdown
  
  dependencies = {
    "nvim-lua/plenary.nvim", -- Biblioteca de utilidades estándar de Lua
    -- Asegúrate de tener nvim-cmp si quieres autocompletado de enlaces [[...]]
    -- "hrsh7th/nvim-cmp", 
  },
  opts = {
    workspaces = {
      {
        name = "personal",
        path = "~/notes",
      },
    },

    -- Configuración de Notas Diarias
    daily_notes = {
      folder = "diario",
      date_format = "%Y-%m-%d",
      template = nil, -- Puedes crear templates más adelante
    },

    -- Completado de enlaces [[ ]]
    completion = {
      nvim_cmp = true,
      min_chars = 2,
    },
    -- Frontmatter automático (Metadatos YAML al inicio del archivo)
    disable_frontmatter = true,
    note_id_func = function(title)
      -- Si hay un título, úsalo como nombre de archivo
      if title ~= nil then
        -- Opción A: Mantener mayúsculas y espacios (Windows style)
        -- return title
        
        -- Opción B: Convertir a formato Linux (kebab-case) <- RECOMENDADO
        -- "Hola Mundo" se convierte en "hola-mundo"
        return title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      else
        -- Si no das título, usa 4 letras al azar para no romper nada
        local suffix = ""
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
        return suffix
      end
    end,
    -- Mapeos de teclas específicos para el buffer de Obsidian
    mappings = {
      -- "gf" (Go to File) es nativo de Vim, pero aquí se sobrecarga 
      -- para entender enlaces de Obsidian y crear notas si no existen.
      ["gf"] = {
        action = function()
          return require("obsidian").util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },
      -- Checkbox toggle con <leader>ch
      ["<leader>ch"] = {
        action = function()
          return require("obsidian").util.toggle_checkbox()
        end,
        opts = { buffer = true },
      },
    },
    
    -- UI: Personalización visual ligera
    ui = {
      enable = true,  -- Habilita decoraciones (checkboxes, bullets)
    },
  },
}
