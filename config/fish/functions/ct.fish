function ct --description 'Generate ctags'
  ctags -R -f ./.git/tags .
end
