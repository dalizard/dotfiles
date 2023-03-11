OS_NAME := $(shell uname -s | tr A-Z a-z)

excluded_dotfiles := Makefile

ifeq ($(OS_NAME), darwin)
	excluded_dotfiles += fvwm
endif

dotfiles := $(filter-out $(excluded_dotfiles), $(wildcard *))

formulae := \
	bat \
	cheat \
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
install: | link fisher ruby vim_plug neovim
endif

update: | install
	@echo '==> Updating world...'
ifeq ($(OS_NAME), darwin)
	@sudo port selfupdate
endif
	@fish -c 'fisher update'
	@vim +PlugUpgrade +PlugInstall +PlugUpdate +qall

clean: | install
	@echo '==> Cleaning world...'
ifeq ($(OS_NAME), darwin)
ifneq ($(shell port installed inactive),)
	@sudo port uninstall inactive
endif
endif
	@vim +PlugClean +qall
	@rm -f config/nvim/autoload/plug.vim.old

### Linking
prefixed_symlinks = $(addprefix $(HOME)/.,$(dotfiles))
kitty_current_theme = $(HOME)/.config/kitty/current-theme.conf
kitty_os_conf = $(HOME)/.config/kitty/os.conf

link: | $(prefixed_symlinks) $(kitty_current_theme) $(kitty_os_conf)

$(prefixed_symlinks):
	@echo '==> Link dotfiles to home directory...'
	@$(foreach val, $(dotfiles), ln -sfn $(abspath $(val)) $(HOME)/.$(val);)

$(kitty_current_theme):
	@mkdir -p $(HOME)/.config
	@cp $(HOME)/.dotfiles/config/kitty/themes/dark.conf $(HOME)/.config/kitty/current-theme.conf

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
$(ruby): | $(HOME)/.ruby-version
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
ifeq ($(OS_NAME), darwin)
bin_path := /opt/local/bin
else
bin_path := /usr/local/bin
endif

vim = $(bin_path)/vim
vi = $(bin_path)/vi
neovim: | $(vim) $(vi)
$(vim):
	sudo ln -sfn $(bin_path)/nvim $(bin_path)/vim
$(vi):
	sudo ln -sfn $(bin_path)/nvim $(bin_path)/vi

### Fish plugin manager
fisher = $(HOME)/.config/fish/functions/fisher.fish
fisher: $(fisher)
$(fisher):
	@echo '==> Installing fisher plugin manager...'
	@fish -c 'curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher'
