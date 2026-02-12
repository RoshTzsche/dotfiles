return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter", -- Optimization: Load only when you start typing
  dependencies = {
    "hrsh7th/cmp-buffer", -- Source: words in the current file
    "hrsh7th/cmp-path",   -- Source: filesystem paths
    "L3MON4D3/LuaSnip",   -- Snippet Engine (Required)
    "saadparwaiz1/cmp_luasnip", -- Bridge between cmp and LuaSnip
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
        ["<C-Space>"] = cmp.mapping.complete(), -- Force menu
        ["<C-e>"] = cmp.mapping.abort(), -- Close menu
        ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Enter to confirm
      }),

      -- 3. Autocompletion Sources (Order matters)
      sources = cmp.config.sources({
        { name = "obsidian" }, -- Priority 1: Your notes
        { name = "obsidian_new" }, -- Priority 2: Create new notes
        { name = "luasnip" },  -- Priority 3: Snippets
        { name = "buffer" },   -- Priority 4: Text in file
        { name = "path" },     -- Priority 5: File paths
      }),
    })
  end,
}
