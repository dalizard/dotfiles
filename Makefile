SHELL := /usr/local/bin/fish
OS_NAME := $(shell uname -s | tr A-Z a-z)

excluded_dotfiles := Makefile
dotfiles := $(filter-out $(excluded_dotfiles), $(wildcard *))

formulae := \
	bat \
	chruby \
	chruby-fish \
	dash \
	elixir \
	erlang \
	fd \
	fish \
	fzf \
	git \
	hub \
	neovim \
	nnn \
	openssl@1.1 \
	postgresql \
	rebar3 \
	ripgrep \
	ruby-install \
	rust \
	sqlite \
	tldr \
	tmux \
	universal-ctags

default: | update clean

ifeq ($(OS_NAME), freebsd)
install: | link fisher ruby vim_plug term_db
else
install: | brew link fisher ruby vim_plug neovim term_db
endif

update: | install
	@echo '==> Updating world...'
ifeq ($(OS_NAME), darwin)
	@brew update
	@brew upgrade
endif
	@$(gem) update
	@$(gem) update --system
	@fisher update
	@vim +PlugUpgrade +PlugInstall +PlugUpdate +qall

clean: | install
	@echo '==> Cleaning world...'
ifeq ($(OS_NAME), darwin)
	@brew cleanup -s
endif
	@$(gem) clean
	@vim +PlugClean +qall

### Homebrew
homebrew_root := /usr/local
cellar := $(homebrew_root)/Cellar
prefixed_formulae := $(addprefix $(cellar)/,$(notdir $(formulae)))
homebrew := $(homebrew_root)/bin/brew

brew: | $(homebrew) $(prefixed_formulae)

$(homebrew):
	ruby -e "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew analytics off

$(prefixed_formulae): | $(homebrew)
	brew install $(notdir $@)

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
	@curl -LO http://invisible-island.net/datafiles/current/terminfo.src.gz
	@gunzip terminfo.src.gz
	@tic -x terminfo.src
	@rm terminfo.src

### Fish plugin manager
fisher = $(HOME)/.config/fish/functions/fisher.fish

fisher: $(fisher)

$(fisher):
	@echo '==> Installing fisher plugin manager...'
	@curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
