return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp", -- The vital autocompletion bridge
  },
  config = function()
    -- 1. Start Mason (The Installer)
    require("mason").setup()
    
    -- Define capabilities once for all servers
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    -- 2. Configure Mason-LSPConfig with "Handlers" (Modern Architecture)
    require("mason-lspconfig").setup({
      ensure_installed = { "pyright", "lua_ls" }, -- What we absolutely need
      
      -- HERE IS THE MAGIC: Automatic handlers
      handlers = {
        -- Default handler: Applies to any server without special config
        function(server_name)
          require("lspconfig")[server_name].setup({
            capabilities = capabilities,
          })
        end,

        -- Specific handler for PYTHON (Pyright)
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

        -- Specific handler for LUA
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

    -- 3. KEYBINDS (Keymaps)
    -- This only activates when an LSP server attaches to your buffer
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf }
        
        -- Go to definition (gd)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        -- View floating documentation (K)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        -- Rename variable (Space + r)
        vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, opts)
        -- Code actions (Space + ca)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
      end,
    })
  end,
}
