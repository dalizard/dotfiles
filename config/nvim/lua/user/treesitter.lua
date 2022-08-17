local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  return
end

configs.setup {
  highlight = {
    enable = true,
    disable = {},
    additional_vim_regex_highlighting = true
  },
  indent = {
    enable = true,
    disable = { "yaml" },
  },
  ensure_installed = {
    'tsx',
    'typescript',
    'javascript',
    'fish',
    'ruby',
    'go',
    'rust',
    'yaml',
    'html',
    'css'
  }
}
