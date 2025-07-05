local hotkeys = {
  [1] = { name = 'kitty' },
  [2] = { name = 'Firefox' },
  [3] = { name = 'Safari' },
  [4] = { name = 'Dash' },
  [5] = { name = 'Slack' },
}

for key, obj in pairs(hotkeys) do
  hs.hotkey.bind({ "cmd", "ctrl" }, tostring(key), function() hs.application.launchOrFocus(obj.name) end)
end
