return {
  "Vigemus/iron.nvim",
  event = "VeryLazy", 
  
  config = function()
    local iron = require("iron.core")
    local view = require("iron.view")
    local common = require("iron.fts.common")
    iron.setup({
      config = {
        -- REPL Definitions: Define which binary executes each language.
        repl_definition = {
          python = {
            command = { "python3" },
	    format = common.bracketed_paste_python,
	    block_dividers = {"# %%", "#%%"},
	    env = {PYTHON_BASIC_REPL = "1"}
          },
          sh = {
            command = {"zsh"} -- Or bash, depending on your shell
          }
        },
        -- How the REPL window opens
        -- Vertical split 
        repl_open_cmd = view.split.vertical.botright("30%"),
      },
      
      -- Highlight configuration when sending code
      highlight = {
        italic = true
      },
      
      -- Ignore floating windows to prevent conflicts with lazy.nvim or wofi
      ignore_blank_lines = true, 
    })

    -- YOUR KEYBINDS (This is where you take control)
    -- Iron has its own internal mappings, but it's better to define them via vim.keymap
    -- for consistency with your Leader Key.
    
    -- Map to toggle the REPL
    vim.keymap.set('n', '<leader>rr', '<cmd>IronRepl<cr>', { desc = "REPL Toggle" })
    
    -- Map to restart the REPL (useful if Python hangs)
    vim.keymap.set('n', '<leader>rt', '<cmd>IronRestart<cr>', { desc = "REPL Restart" })
    
    -- Map to send the whole file
    vim.keymap.set('n', '<leader>rf', function() iron.send_file() end, { desc = "REPL Send File" })

    -- NOTE: To send lines or visual selection, Iron requires an operator.
    -- Configure this below following the documentation.
    -- Map to send motions. 
    -- Pressing <leader>s, Vim will wait for you to specify "what" to send (e.g., <leader>sip sends the paragraph).
	vim.keymap.set("n", "<leader>s", function()
  		iron.run_motion("send_motion")
	end, { desc = "REPL Send Motion" })
    -- Map to send current visual selection
	vim.keymap.set("v", "<leader>s", function()
  		iron.visual_send()
	end, { desc = "REPL Visual Send" })
  end
}
