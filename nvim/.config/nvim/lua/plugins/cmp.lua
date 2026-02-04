return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter", -- Optimización: Solo carga cuando empiezas a escribir
  dependencies = {
    "hrsh7th/cmp-buffer", -- Fuente: palabras en el archivo actual
    "hrsh7th/cmp-path",   -- Fuente: rutas del sistema de archivos
    "L3MON4D3/LuaSnip",   -- Motor de Snippets (Obligatorio)
    "saadparwaiz1/cmp_luasnip", -- Puente entre cmp y LuaSnip
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      
      mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(), -- Forzar menú
        ["<C-e>"] = cmp.mapping.abort(), -- Cerrar menú
        ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Enter confirma
      }),

      -- 3. Fuentes de Autocompletado (El orden importa)
      sources = cmp.config.sources({
        { name = "obsidian" }, -- Prioridad 1: Tus notas
        { name = "obsidian_new" }, -- Prioridad 2: Crear notas nuevas
        { name = "luasnip" },  -- Prioridad 3: Snippets
        { name = "buffer" },   -- Prioridad 4: Texto en el archivo
        { name = "path" },     -- Prioridad 5: Rutas de archivos
      }),
    })
  end,
}
