return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp", -- El puente vital para autocompletado
  },
  config = function()
    -- 1. THE VOCABULARY (Capabilities)
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- ==========================================
    -- 2. THE BLUEPRINTS (Native Declarations)
    -- ==========================================

-- A) Define Python (Pyright) natively
vim.lsp.config('pyright', {
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

-- B) Define Typst (Tinymist) natively
vim.lsp.config('tinymist', {
  capabilities = capabilities,
  settings = {
    exportPdf = "onType",
    outputPath = "$root/$dir/$name",
    formatterMode = "typstyle",
    semanticTokens = "disable"
  }
})

-- C) Define Lua natively
vim.lsp.config('lua_ls', {
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
    },
  },
})
    -- [!] ASSEMBLE HERE: Paste the vim.lsp.config('pyright', ...) block
    
    -- [!] ASSEMBLE HERE: Paste the vim.lsp.config('tinymist', ...) block
    
    -- [!] ASSEMBLE HERE: Paste the vim.lsp.config('lua_ls', ...) block

    -- ==========================================
    -- 3. THE IGNITION (Mason & Bridge)
    -- ==========================================
    require("mason").setup()
    
    require("mason-lspconfig").setup({
      ensure_installed = { "pyright", "lua_ls", "tinymist" },
      -- automatic_enable = true is implied in v2.0.0+
    })

    -- ==========================================
    -- 4. THE INTERACTIVITY (Keybindings)
    -- ==========================================
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
      end,
    })
  end,
}
