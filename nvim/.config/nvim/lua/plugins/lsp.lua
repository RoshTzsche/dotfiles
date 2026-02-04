return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp", -- El puente de autocompletado vital
  },
  config = function()
    -- 1. Iniciar Mason (El instalador)
    require("mason").setup()
    
    -- Definir capabilities una sola vez para todos los servidores
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    -- 2. Configurar Mason-LSPConfig con "Handlers" (Arquitectura Moderna)
    require("mason-lspconfig").setup({
      ensure_installed = { "pyright", "lua_ls" }, -- Lo que queremos sí o sí
      
      -- AQUÍ ESTÁ LA MAGIA: Handlers automáticos
      handlers = {
        -- Handler por defecto: Se aplica a cualquier servidor sin config especial
        function(server_name)
          require("lspconfig")[server_name].setup({
            capabilities = capabilities,
          })
        end,

        -- Handler específico para PYTHON (Pyright)
        ["pyright"] = function()
          require("lspconfig").pyright.setup({
            capabilities = capabilities,
            settings = {
              python = {
                analysis = {
                  autoSearchPaths = true,
                  useLibraryCodeForTypes = true,
                  diagnosticMode = "workspace",
                },
              },
            },
          })
        end,

        -- Handler específico para LUA
        ["lua_ls"] = function()
          require("lspconfig").lua_ls.setup({
            capabilities = capabilities,
            settings = {
              Lua = {
                diagnostics = { globals = { "vim" } },
              },
            },
          })
        end,
      }
    })

    -- 3. ATAJOS DE TECLADO (Keymaps)
    -- Esto solo se activa cuando un servidor LSP se conecta a tu buffer
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf }
        
        -- Ir a definición (gd)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        -- Ver documentación flotante (K)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        -- Renombrar variable (Espacio + r)
        vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, opts)
        -- Acciones de código (Espacio + ca)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
      end,
    })
  end,
}
