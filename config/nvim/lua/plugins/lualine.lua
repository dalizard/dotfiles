
return {
  "nvim-lualine/lualine.nvim",
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
  options = {
    icons_enabled = true,
    theme = 'lagadath',
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = true,
    refresh = {
      statusline = 200,
      tabline = 500,
      winbar = 300,
    }
  },

  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'diagnostics' },
    lualine_c = { 'filename' },
    lualine_x = {
      {
        'copilot',
        symbols = {
          status = {
            icons = {
              enabled = " ",
              sleep = " ", -- auto-trigger disabled
              disabled = " ",
              warning = " ",
              unknown = " "
            },
            hl = {
              enabled = "#50FA7B",
              sleep = "#AEB7D0",
              disabled = "#6272A4",
              warning = "#FFB86C",
              unknown = "#FF5555"
            }
          },
          spinners = "dots",       -- has some premade spinners
          spinner_color = "#6272A4"
        },
        show_colors = false,
        show_loading = true
      }, 'encoding', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
  }
}
