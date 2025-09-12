local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
  return
end

local snip = luasnip.snippet
local text = luasnip.text_node
local insert = luasnip.insert_node
local func = luasnip.function_node

local date = function()
  return { os.date "%Y-%m-%d" }
end

local function dash(_, _, command)
  local file = io.popen(command, "r")
  local res = {}
  for line in file:lines() do
    table.insert(res, line)
  end
  return res
end

luasnip.config.set_config({
  store_selection_keys = '<Tab>',
})

luasnip.add_snippets(nil, {
  all = {
    snip({
      trig = "date",
      namr = "Date",
      dscr = "Date in the form of YYYY-MM-DD",
    }, {
      func(date, {}),
    }),
    snip({
      trig = "pwd",
      namr = "PWD",
      dscr = "Path to current working directory",
    }, {
      func(dash, {}, { user_args = { "pwd" } }),
    }),
  },
  markdown = {
    -- Select link, press C-s, enter link to receive snippet
    snip({
      trig = "link",
      namr = "markdown_link",
      dscr = "Create markdown link [txt](url)",
    }, {
      text "[",
      insert(1),
      text "](",
      func(function(_, snip)
        return snip.env.TM_SELECTED_TEXT[1] or {}
      end, {}),
      text ")",
      insert(0),
    }),
  },
})
