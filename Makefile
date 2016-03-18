DOTPATH    := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
CANDIDATES := $(wildcard *)
EXCLUSIONS := Makefile
DOTFILES   := $(filter-out $(EXCLUSIONS), $(CANDIDATES))

.PHONY: install clean update

install:
	@echo '==> Deploy dotfiles to home directory...'
	@$(foreach val, $(DOTFILES), ln -sfnv $(abspath $(val)) $(HOME)/.$(val);)

clean:
	@echo '==> Remove linked dotfiles in home directory...'
	@-$(foreach val, $(DOTFILES), rm -vrf $(HOME)/.$(val);)

update:
	@git pull origin master
	@git submodule foreach git pull origin master
