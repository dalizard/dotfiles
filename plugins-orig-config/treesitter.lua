local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  return
end

configs.setup {
  ignore_install = {},
  sync_install = false,
  auto_install = false,
  highlight = {
    enable = true,
    disable = { "markdown" },
    additional_vim_regex_highlighting = false,
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
    "gitignore",
    "go",
    "gomod",
    "graphql",
    "hcl",
    "html",
    "http",
    "javascript",
    "jsdoc",
    "json",
    "json5",
    "lua",
    "make",
    "markdown",
    "query",
    "regex",
    "ruby",
    "rust",
    "scheme",
    "scss",
    "slim",
    "sql",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
    "yaml",
  }
}
