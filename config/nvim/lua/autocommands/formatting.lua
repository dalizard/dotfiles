vim.api.nvim_create_augroup("_formatting", { clear = true })

-- TODO: Move this into a function
-- Strip trailing whitespaces on save
--vim.api.nvim_create_autocmd({ "BufWritePre" }, {
--  group = "_formatting",
--  pattern = "*",
--  command = "%s/\\s\\+$//e"
--})

-- Only show cursorline in the current window and in normal mode
vim.api.nvim_create_autocmd({ "WinLeave", "InsertEnter" }, {
  group = "_formatting",
  pattern = "*",
  callback = function()
    vim.cmd("set nocursorline")
  end,
})
vim.api.nvim_create_autocmd({ "WinEnter", "InsertLeave" }, {
  group = "_formatting",
  pattern = "*",
  callback = function()
    vim.cmd("set cursorline")
  end,
})

-- Diable automatic comment insertion
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = "_formatting",
  pattern = "*",
  callback = function()
    -- For some reason formatoptions:remove is not working, so...
    vim.cmd("set formatoptions-=cro")
  end,
})
