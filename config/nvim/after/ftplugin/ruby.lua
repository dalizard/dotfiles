vim.opt_local.iskeyword:append({ "?", "!" })

-- Disable tree-sitter re-indentation for `.`
vim.opt_local.indentkeys:remove(".")
