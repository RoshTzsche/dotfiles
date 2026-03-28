-- Exclusive mapping for the current buffer (.typ files)
vim.keymap.set("n", "<leader>t", function()
  -- 1. Capture the absolute path of the current file and change the extension to .pdf
  local pdf_path = vim.fn.expand("%:p:r") .. ".pdf"
  
  -- 2. Verify if the engine (Tinymist) has already compiled the binary
  if vim.fn.filereadable(pdf_path) == 1 then
    -- 3. Inject Zathura into the OS without blocking the Neovim thread
    vim.fn.jobstart({"zathura", pdf_path}, { detach = true })
    print("Vision active: Zathura -> " .. vim.fn.expand("%:t:r") .. ".pdf")
  else
    print("I/O Failure: PDF does not exist. Save the file so Tinymist can generate it.")
  end
end, { buffer = true, desc = "Spawn Zathura (Typst)", silent = true })
