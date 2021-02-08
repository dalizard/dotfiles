SHELL := /usr/local/bin/fish

default: | update clean

install: | link ruby vim_plug term_db

update: | install
	@echo '==> Updating world...'
	$(gem) update
	$(gem) update --system
	fisher update
	vim +PlugUpgrade +PlugInstall +PlugUpdate +qall

clean: | install
	@echo '==> Cleaning world...'
	$(gem) clean
	vim +PlugClean +qall

### Linking
prefixed_symlinks = $(addprefix $(HOME)/.,$(dotfiles))

link: | $(prefixed_symlinks)

$(prefixed_symlinks):
	@echo '==> Link dotfiles to home directory...'
	@$(foreach val, $(dotfiles), ln -sfnv $(abspath $(val)) $(HOME)/.$(val);)

### Unlinking
unlink:
	@echo '==> Remove linked dotfiles in home directory...'
	@-$(foreach val, $(dotfiles), rm -vrf $(HOME)/.$(val);)

### Ruby
ruby_version := $(shell cat $(PWD)/ruby-version)
ruby_dir = $(HOME)/.rubies
ruby = $(ruby_dir)/ruby-$(ruby_version)
gem = $(ruby)/bin/gem

ruby: | $(ruby) $(bundler)

$(ruby): | $(brew) $(HOME)/.ruby-version
	ruby-install ruby-$(ruby_version) -i $(ruby_versions)/ruby-$(ruby_version)

### Bundler
bundler = $(ruby)/bin/bundle

$(bundler): | $(ruby)
	$(gem) install bundler

### plug.vim
vim_plug = $(HOME)/.config/nvim/autoload/plug.vim

vim_plug: | $(vim_plug)

$(vim_plug):
	curl -fLo $(vim_plug) --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	mkdir -p $(HOME)/.nvim/tmp

### Neovim
vim = /usr/local/bin/vim
vi = /usr/local/bin/vi

neovim: | $(vim) $(vi)

$(vim):
	ln -sfnv /usr/local/bin/nvim /usr/local/bin/vim
$(vi):
	ln -sfnv /usr/local/bin/nvim /usr/local/bin/vi

### Terminal database
term_db = $(HOME)/.terminfo

term_db: $(term_db)

$(term_db):
	@echo '==> Installing latest terminal database...'
	curl -LO http://invisible-island.net/datafiles/current/terminfo.src.gz
	gunzip terminfo.src.gz
	tic -x terminfo.src
	rm terminfo.src
