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
    disable = { "ruby", "yaml" },
  },
  ensure_installed = {
    "css",
    "dockerfile",
    "fish",
    "go",
    "gomod",
    "graphql",
    "hcl",
    "html",
    "javascript",
    "jsdoc",
    "json",
    "json5",
    "lua",
    "markdown",
    "ruby",
    "rust",
    "scss",
    "sql",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "yaml",
  }
}
