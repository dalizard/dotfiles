SHELL := $(shell which fish)
OS_NAME := $(shell uname -s | tr A-Z a-z)

excluded_dotfiles := Makefile

ifeq ($(OS_NAME), darwin)
	excluded_dotfiles += fvwm
endif

dotfiles := $(filter-out $(excluded_dotfiles), $(wildcard *))

formulae := \
	bat \
	dash \
	erlang \
	fd \
	fish \
	fzf \
	gh \
	git \
	go \
	htop \
	luajit \
	neovim \
	nnn \
	ripgrep \
	ruby-install \
	rust \
	sqlite \
	starship \
	tldr \
	tmux \
	universal-ctags

default: | update clean

ifneq (,$(filter $(OS_NAME), freebsd openbsd))
install: | link fisher ruby vim_plug
else
install: | brew link fisher ruby vim_plug neovim
endif

update: | install
	@echo '==> Updating world...'
ifeq ($(OS_NAME), darwin)
	@brew update
	@brew upgrade
endif
	@fisher update
	@vim +PlugUpgrade +PlugInstall +PlugUpdate +qall

clean: | install
	@echo '==> Cleaning world...'
ifeq ($(OS_NAME), darwin)
	@brew cleanup -s
endif
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

link: | $(prefixed_symlinks) kitty_current_theme kitty_os_conf

$(prefixed_symlinks):
	@echo '==> Link dotfiles to home directory...'
	@$(foreach val, $(dotfiles), ln -sfn $(abspath $(val)) $(HOME)/.$(val);)

### kitty config
kitty_current_theme = $(HOME)/.config/kitty/current-theme.conf
kitty_current_theme: | $(kitty_current_theme)
$(kitty_current_theme):
	@cp $(HOME)/.config/kitty/themes/dark.conf $(HOME)/.config/kitty/current-theme.conf

kitty_os_conf = $(HOME)/.config/kitty/os.conf
kitty_os_conf: | $(kitty_os_conf)
$(kitty_os_conf):
ifeq ($(OS_NAME), darwin)
	@ln -sfn $(HOME)/.config/kitty/darwin.conf $(HOME)/.config/kitty/os.conf
else
	@ln -sfn $(HOME)/.config/kitty/non-darwin.conf $(HOME)/.config/kitty/os.conf
endif


### Unlinking
unlink:
	@echo '==> Remove linked dotfiles in home directory...'
	@-$(foreach val, $(dotfiles), rm -rf $(HOME)/.$(val);)

### Ruby
ruby_version := $(shell cat $(PWD)/ruby-version)
ruby_dir = $(HOME)/.rubies
ruby = $(ruby_dir)/ruby-$(ruby_version)
gem = $(ruby)/bin/gem

ruby: | $(ruby) $(bundler)

$(ruby): | $(brew) $(HOME)/.ruby-version
	ruby-install ruby-$(ruby_version) -i $(ruby_dir)/ruby-$(ruby_version)

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
	ln -sfn /usr/local/bin/nvim /usr/local/bin/vim
$(vi):
	ln -sfn /usr/local/bin/nvim /usr/local/bin/vi

### Fish plugin manager
fisher = $(HOME)/.config/fish/functions/fisher.fish

fisher: $(fisher)

$(fisher):
	@echo '==> Installing fisher plugin manager...'
	@curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
