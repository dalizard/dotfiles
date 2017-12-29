nnoremap  <leader>t :!erlc -DTEST %; erl -noshell -pa . -eval "eunit:test(%:r, [verbose])" -s init stop<cr>
