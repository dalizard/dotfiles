-- Return to last edit position when opening files
vim.api.nvim_create_autocmd("BufReadPost", {
  group = vim.api.nvim_create_augroup("general", { clear = true }),
  callback = function()
    if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") and
        vim.bo.filetype ~= 'gitcommit' then
      vim.fn.setpos('.', vim.fn.getpos("'\""))
      vim.cmd("normal! g`\"")
    end
  end
})

local formatting = vim.api.nvim_create_augroup("formatting", { clear = true })

-- Only show cursorline in the current window and in normal mode
vim.api.nvim_create_autocmd({ "WinLeave", "InsertEnter" }, {
  group = formatting,
  command = "setlocal nocursorline",
})

vim.api.nvim_create_autocmd({ "WinEnter", "InsertLeave" }, {
  group = formatting,
  command = "setlocal cursorline",
})

-- Disable automatic comment insertion
vim.api.nvim_create_autocmd("FileType", {
  group = formatting,
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end
})

-- Browse the commit under cursor in fugitive blame
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("git", { clear = true }),
  pattern = "fugitiveblame",
  callback = function()
    vim.keymap.set("n", "<leader>gb", function()
      vim.cmd("execute ':GBrowse ' .. vim.fn.expand('<cword>')")
    end, { desc = "Browse commit under cursor" })
  end
})
