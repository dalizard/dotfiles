vim.api.nvim_create_user_command('AC', function() vim.cmd('vsplit ' .. vim.fn.eval('rails#buffer().alternate()')) end, {})
