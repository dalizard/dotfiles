vim.api.nvim_create_augroup("_git", { clear = true })

-- Browse the commit under cursor
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = "_git",
  pattern = "fugitiveblame",
  callback = function()
    vim.keymap.set("n", "<leader>gb", function()
      vim.cmd("execute ':GBrowse ' .. vim.fn.expand('<cword>')")
    end, { desc = "Browse commit under cursor" })
  end,
})
