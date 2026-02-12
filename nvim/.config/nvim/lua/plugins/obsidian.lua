return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
    "nvim-telescope/telescope.nvim", -- <--- PIEZA FALTANTE CRÍTICA
  },

  -- Atajos para cargar el plugin sin abrir un archivo primero
  keys = {
    { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "Nueva Nota Obsidian" },
    { "<leader>ot", "<cmd>ObsidianTemplate<cr>", desc = "Insertar Plantilla" },
    { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Buscar en Vault" },
  },

  opts = {
	  picker = {
    name = "telescope.nvim",
    -- Opcional: Personaliza el aspecto si quieres que sea diferente al default
    -- note_mappings = { ... } 
  },
    workspaces = {
      {
        name = "personal",
        path = "~/notes",
      },
    },

    daily_notes = {
      folder = "diario",
      date_format = "%Y-%m-%d",
      template = nil, 
    },

    -- CONFIGURACIÓN DE PLANTILLAS (Simple y Directa)
    templates = {
      subdir = "templates", -- Ruta física: ~/notes/templates
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
      substitutions = {
        -- Solo mantenemos lo esencial para tu bitácora
        fresco = "Estado: 🟢 Fresco.",
      },
    },

    -- Corrección Estructural: Todo esto ahora vive DENTRO de opts
    completion = {
      nvim_cmp = true,
      min_chars = 2,
    },

    disable_frontmatter = true,

    note_id_func = function(title)
      if title ~= nil then
        -- Kebab-case para nombres de archivo limpios en Linux
        return title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      else
        local suffix = ""
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
        return suffix
      end
    end,

    mappings = {
      ["gf"] = {
        action = function() return require("obsidian").util.gf_passthrough() end,
        opts = { noremap = false, expr = true, buffer = true },
      },
      ["<leader>ch"] = {
        action = function() return require("obsidian").util.toggle_checkbox() end,
        opts = { buffer = true },
      },
    },

    ui = {
      enable = true, 
    },
  }, 
}
