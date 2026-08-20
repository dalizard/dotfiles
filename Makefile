OS_NAME := $(shell uname -s | tr A-Z a-z)

# agents/ must not become ~/.agents: that dir is owned by the skill installer.
excluded_dotfiles := Makefile agents

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
	mise \
	neovim \
	nnn \
	ripgrep \
	rust \
	sqlite \
	starship \
	tldr \
	tmux \
	universal-ctags

default: | update clean

ifneq (,$(filter $(OS_NAME), freebsd openbsd))
install: | link fisher
else ifeq ($(OS_NAME), darwin)
install: | brew link fisher neovim
else
install: | link fisher neovim
endif

update: | install
	@echo '==> Updating world...'
ifeq ($(OS_NAME), darwin)
	@brew update
	@brew upgrade
endif
	@fish -c 'fisher update'
	@nvim --headless '+lua vim.pack.update(nil, { force = true })' +qa
	@git diff --quiet HEAD -- config/nvim/nvim-pack-lock.json \
		|| git commit -m 'Update nvim plugins' -- config/nvim/nvim-pack-lock.json

clean: | install
	@echo '==> Cleaning world...'
ifeq ($(OS_NAME), darwin)
	@brew cleanup -s
endif

### Homebrew
cellar := /opt/homebrew/Cellar
prefixed_formulae := $(addprefix $(cellar)/,$(formulae))

brew: | $(prefixed_formulae)

$(prefixed_formulae):
	brew install $(notdir $@)

### Linking
prefixed_symlinks = $(addprefix $(HOME)/.,$(dotfiles))
kitty_current_theme = $(HOME)/.config/kitty/current-theme.conf
kitty_os_conf = $(HOME)/.config/kitty/os.conf
personal_skills := $(notdir $(shell find claude/skills -mindepth 1 -maxdepth 1 -type d))

link: | $(prefixed_symlinks) $(kitty_current_theme) $(kitty_os_conf) agents_skills agents_instructions

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

# Codex and other agents discover skills in ~/.agents/skills; the dir itself is
# owned by the skill installer, so link each personal skill rather than the tree.
.PHONY: agents_skills
agents_skills:
	@echo '==> Link personal skills to ~/.agents/skills...'
	@mkdir -p $(HOME)/.agents/skills
	@$(foreach val, $(personal_skills), ln -sfn $(abspath claude/skills/$(val)) $(HOME)/.agents/skills/$(val);)

# agents/AGENTS.md is the canonical instructions file; claude/CLAUDE.md is a
# repo-relative symlink to it, so Claude Code needs no link here.
.PHONY: agents_instructions
agents_instructions:
	@echo '==> Link AGENTS.md as global agent instructions...'
	@mkdir -p $(HOME)/.codex $(HOME)/.gemini
	@ln -sfn $(abspath agents/AGENTS.md) $(HOME)/.codex/AGENTS.md
	@ln -sfn $(abspath agents/AGENTS.md) $(HOME)/.gemini/GEMINI.md

### Unlinking
unlink:
	@echo '==> Remove linked dotfiles in home directory...'
	@-$(foreach val, $(dotfiles), rm -rf $(HOME)/.$(val);)

### Neovim
ifeq ($(OS_NAME), darwin)
nvim_path := /opt/homebrew/bin/nvim
else
nvim_path := /usr/local/bin/nvim
endif

vim = /usr/local/bin/vim
vi = /usr/local/bin/vi
neovim: | $(vim) $(vi)
$(vim):
	sudo ln -sfn $(nvim_path) $(vim)
$(vi):
	sudo ln -sfn $(nvim_path) $(vi)

### Fish plugin manager
fisher = $(HOME)/.config/fish/functions/fisher.fish
fisher: $(fisher)
$(fisher):
	@echo '==> Installing fisher plugin manager...'
	@fish -c 'curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher'
