return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp", -- El puente vital para autocompletado
  },
  config = function()
    -- 1. Iniciar Mason (El Gestor de Binarios)
    require("mason").setup()
    
    -- 2. Declarar las capacidades (Capabilities) para CMP
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- 3. Iniciar Mason-LSPConfig (La lista de instalación)
    require("mason-lspconfig").setup({
      ensure_installed = { "pyright", "lua_ls", "tinymist" },
    })

    -- 4. CONFIGURACIÓN EXACTA DE SERVIDORES (Handlers)
    require("mason-lspconfig").setup_handlers({
      
      -- A) Handler por defecto (Para cualquier LSP sin config especial)
      function(server_name)
        require("lspconfig")[server_name].setup({
          capabilities = capabilities,
        })
      end,

      -- B) Handler para PYTHON
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

      -- C) Handler para TYPST (La Visión de Zathura)
      ["tinymist"] = function()
        require("lspconfig").tinymist.setup({
          capabilities = capabilities,
          settings = {
            exportPdf = "onSave",
            outputPath = "$root/$dir/$name",
            formatterMode = "typstyle",
            semanticTokens = "disable"
          }
        })
      end,

      -- D) Handler para LUA
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
    })

    -- 5. ATAJOS DE TECLADO (LspAttach)
    -- Solo se activan cuando un LSP se conecta exitosamente a tu buffer
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf }
        -- Ir a definición
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        -- Ver documentación flotante
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        -- Renombrar variable
        vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, opts)
        -- Acciones de código
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
      end,
    })
  end,
}
