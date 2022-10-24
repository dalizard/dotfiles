local status_ok, neotest = pcall(require, "neotest")
if not status_ok then
  return
end

local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set

neotest.setup {
  adapters = {
    require "neotest-rspec",
  },
  icons = {
    expanded = "",
    child_prefix = "",
    child_indent = "",
    final_child_prefix = "",
    non_collapsible = "",
    collapsed = "",
    passed = "",
    running = "",
    failed = "",
    unknown = "",
  },
  floating = {
    options = {
      winhl = "NormalFloat:NONE",
    }
  },
  summary = {
    mappings = {
      expand = { "l", "h", "<CR>" },
      stop = "s",
    },
  },
}

keymap("n", "<leader>ta", neotest.run.attach, opts)
keymap("n", "<leader>l", neotest.run.run_last, opts)
keymap("n", "<leader>s", neotest.run.run, opts)
keymap("n", "<leader>ts", neotest.summary.toggle, opts)
keymap("n", "<leader>tS", neotest.run.stop, opts)
keymap("n", "<leader>to", neotest.output.open, opts)
keymap("n", "]t", neotest.jump.next, opts)
keymap("n", "[t", neotest.jump.prev, opts)
keymap("n", "<leader>f", function()
  neotest.run.run(vim.fn.expand "%")
end, opts)
