local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
  return
end

local actions = require "telescope.actions"
local action_layout = require "telescope.actions.layout"

telescope.setup{
  defaults = {
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-p>"] = action_layout.toggle_preview,
        ["<C-y>"] = actions.delete_buffer,
      },
      n = {
        ["<C-p>"] = action_layout.toggle_preview,
      }
    },
    layout_strategy = 'flex',
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--hidden",
      "--smart-case"
    },
  },
  pickers = {
    git_files = {
      preview = {
        hide_on_startup = true
      }
    },
    find_files = {
      find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
      preview = {
        hide_on_startup = true
      }
    },
    buffers = {
      preview = {
        hide_on_startup = true
      }
    }
  }
}

telescope.load_extension('fzf')
telescope.load_extension('file_browser')
