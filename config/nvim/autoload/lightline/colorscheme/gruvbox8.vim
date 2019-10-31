if exists('g:lightline')
  let s:inactive_fg = '#646464'
  let s:inactive_bg = '#282828'
  let s:dark_bg  = '#3c3836'
  let s:light_bg = '#504945'
  let s:light_fg = '#a89985'
  let s:bright_fg = '#f0e0b9'
  let s:dark_fg = '#282828'

  let s:normal_bg = '#a89985'
  let s:visual_bg = '#fc802d'
  let s:insert_bg = '#84a598'
  let s:replace_bg = '#8fbf7f'

  let s:base4   = '#a89985'
  let s:base3   = '#c5c8c6'
  let s:base2   = '#bababa'
  let s:base1   = '#a0a0a0'
  let s:base0   = '#909090'
  let s:base00  = '#666666'
  let s:base01  = '#504945'
  let s:base02  = '#282828'
  let s:base023 = '#303030'
  let s:base03  = '#1d1f21'
  let s:red     = '#cc6666'
  let s:orange  = '#ed8642'
  let s:yellow  = '#f0c674'
  let s:green   = '#b5bd68'
  let s:cyan    = '#8abeb7'
  let s:blue    = '#81a2be'
  let s:magenta = '#b294bb'

  let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}
  let s:p.normal.left     = [[s:dark_fg, s:normal_bg]]
  let s:p.normal.middle   = [[s:light_fg, s:dark_bg]]
  let s:p.normal.right    = [[s:dark_fg, s:normal_bg], [s:dark_fg, s:normal_bg]]
  let s:p.normal.error    = [[s:red, s:base023]]
  let s:p.normal.warning  = [[s:yellow, s:base02]]

  let s:p.insert.left     = [[s:dark_fg, s:insert_bg]]
  let s:p.insert.right    = [[s:dark_fg, s:insert_bg], [s:dark_fg, s:insert_bg]]

  let s:p.visual.left     = [[s:dark_fg, s:visual_bg]]
  let s:p.visual.right    = [[s:dark_fg, s:visual_bg], [s:dark_fg, s:visual_bg]]

  let s:p.replace.left    = [[s:dark_fg, s:replace_bg]]
  let s:p.replace.right   = [[s:dark_fg, s:replace_bg], [s:dark_fg, s:replace_bg]]

  let s:p.inactive.right  = [[s:inactive_fg, s:inactive_bg]]
  let s:p.inactive.left   = [[s:inactive_fg, s:inactive_bg]]
  let s:p.inactive.middle = [[s:inactive_fg, s:inactive_bg]]

  let s:p.tabline.left    = [[s:light_fg, s:dark_bg]]
  let s:p.tabline.tabsel  = [[s:dark_fg, s:normal_bg]]
  let s:p.tabline.right   = copy(s:p.normal.right)

  let g:lightline#colorscheme#gruvbox8#palette = lightline#colorscheme#fill(s:p)
endif
