local status_ok, mason = pcall(require, "mason")
if not status_ok then
  return
end

mason.setup({
  registries = {
    "github:mason-org/mason-registry",
  },
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})
