local status_ok, colorizer = pcall(require, "colorizer")
if not status_ok then
  return
end

colorizer.setup({
  filetypes = { "lua" },
  user_default_options = {
    names = false,
    mode = "virtualtext",
  }
})
