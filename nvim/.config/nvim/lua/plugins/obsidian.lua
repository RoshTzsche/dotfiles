return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
    "nvim-telescope/telescope.nvim",
  },

  -- Shortcuts to load the plugin without opening a file first
  keys = {
    { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New Obsidian Note" },
    { "<leader>ot", "<cmd>ObsidianTemplate<cr>", desc = "Insert Template" },
    { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Search Vault" },
  },

  opts = {
	  picker = {
    name = "telescope.nvim",
    -- Optional: Customize the appearance if you want it different from the default
    -- note_mappings = { ... } 
  },
    workspaces = {
      {
        name = "personal",
	-- heey you are going to use obsidian in nvim like me, its so cool, here you need to point to your own file (obsidian)path 
        path = "~/notes",
      },
    },

    daily_notes = {
      folder = "diario",
      date_format = "%Y-%m-%d",
      template = nil, 
    },

    -- TEMPLATES CONFIGURATION (Simple and Direct)
    templates = {
      subdir = "templates", -- Physical path: ~/notes/templates
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
      substitutions = {
        -- Keeping only the essentials for your log
        fresco = "Status: 🟢 Fresh.",
      },
    },

    -- Structural Fix: All this now lives INSIDE opts
    completion = {
      nvim_cmp = true,
      min_chars = 2,
    },

    disable_frontmatter = true,

    note_id_func = function(title)
      if title ~= nil then
        -- Kebab-case for clean filenames in Linux
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
