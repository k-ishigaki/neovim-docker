# Makefile
# supports only linux or mac
fix-path = $1
# make symbolic link at linux
make-link = ln -sf $1 $2;

# target
INIT_FILE := $(PWD)/init.vim
INIT_DIR  := ~/.config/nvim/
PLUGIN_TOMLS := $(PWD)/plugins.toml $(PWD)/lazy.toml
PLUGIN_DIR := ~/.cache/dein/
COLORSCHEME_VIM := $(PWD)/railscasts.vim
COLORSCHEME_DIR := ~/.config/nvim/colors/
GITCONFIG_FILE := $(PWD)/.gitconfig
GITCONFIG_DIR := ~/

# install
.PHONY: install
install:
	mkdir -p $(INIT_DIR)
	mkdir -p $(PLUGIN_DIR)
	mkdir -p $(COLORSCHEME_DIR)
	$(call make-link,$(INIT_FILE),$(INIT_DIR))
	$(foreach f, $(PLUGIN_TOMLS), $(call make-link,$(f),$(PLUGIN_DIR)))
	$(call make-link,$(GITCONFIG_FILE),$(GITCONFIG_DIR))
	$(call make-link,$(COLORSCHEME_VIM),$(COLORSCHEME_DIR))
