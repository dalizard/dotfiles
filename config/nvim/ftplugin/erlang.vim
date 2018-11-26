nnoremap <silent><leader>t :!erlc -DTEST %; erl -noshell -pa . -eval "eunit:test(%:r, [verbose])" -s init stop<cr>
nnoremap <silent><leader>e :sp\|:term erlc %; erl -pa .<cr>\|:startins<cr>
