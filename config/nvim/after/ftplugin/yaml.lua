-- Guard against multiple loads for the same buffer
if vim.b.yaml_path_loaded then
  return
end
vim.b.yaml_path_loaded = true

-- Function to get the YAML path for the current cursor position
local function get_yaml_path()
  local line_num = vim.fn.line('.')
  local lines = vim.api.nvim_buf_get_lines(0, 0, line_num, false)

  local path = {}
  local current_indent = nil

  for i = #lines, 1, -1 do
    local line = lines[i]
    -- Skip empty lines and comments
    if line:match('^%s*$') or line:match('^%s*#') then
      goto continue
    end

    -- Calculate indentation level (number of spaces at start)
    local indent = #line:match('^%s*')

    -- Extract the key (everything before ':')
    -- Handle both regular keys and array items (lines starting with -)
    local key = line:match('^%s*-%s*([^:]+):') or line:match('^%s*([^:]+):')

    if key then
      key = vim.trim(key)
      -- Remove quotes if present
      key = key:gsub('^["\'](.+)["\']$', '%1')

      -- If this is the current line or has less indentation than current
      if current_indent == nil then
        current_indent = indent
        table.insert(path, 1, key)
      elseif indent < current_indent then
        current_indent = indent
        table.insert(path, 1, key)
      end
    end

    ::continue::
  end

  return table.concat(path, '.')
end

-- Copy YAML path to clipboard
vim.keymap.set('n', '<leader>gy', function()
  local ok, path = pcall(get_yaml_path)
  if not ok then
    vim.notify('Error getting YAML path: ' .. tostring(path), vim.log.levels.ERROR)
    return
  end

  if path and path ~= '' then
    vim.fn.setreg('+', path)
    print(path)
    vim.notify('Copied to clipboard: ' .. path, vim.log.levels.INFO)
  else
    vim.notify('No YAML path found', vim.log.levels.WARN)
  end
end, { buffer = true, desc = 'Get YAML path to clipboard' })
