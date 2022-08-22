
local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  return
end

require("mason").setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗"
		}
	}
})
