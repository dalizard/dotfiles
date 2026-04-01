local vue_language_server_path = vim.fn.stdpath('data') ..
    "/mason/packages/vue-language-server/node_modules/@vue/language-server"

local vue_plugin = {
  name = '@vue/typescript-plugin',
  location = vue_language_server_path,
  languages = { 'vue' },
}

return {
  cmd = { 'typescript-language-server', '--stdio' },
  workspace_required = false,
  filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
  root_markers = { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' },
  init_options = {
    plugins = {
      vue_plugin,
    }
  }
}
