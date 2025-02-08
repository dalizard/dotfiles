local status_ok, copilot_cmp = pcall(require, "copilot_cmp")
if not status_ok then
  return
end

copilot_cmp.setup()
