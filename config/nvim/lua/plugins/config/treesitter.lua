local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  return
end

configs.setup {
  ignore_install = {},
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    disable = { "markdown" },
    additional_vim_regex_highlighting = false
  },
  indent = {
    enable = true,
    disable = { "yaml" },
  },
  ensure_installed = {
    "bash",
    "c",
    "comment",
    "css",
    "diff",
    "dockerfile",
    "fish",
    "git_rebase",
    "gitcommit",
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
    "make",
    "markdown",
    "regex",
    "ruby",
    "rust",
    "scheme",
    "scss",
    "sql",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "yaml",
  }
}
