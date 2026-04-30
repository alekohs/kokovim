APPNAME := nvim

.PHONY: all help build run nvim nvim-dev

all: help

help: ## Show this help
	@awk 'BEGIN{FS=":.*## "} /^[a-zA-Z_-]+:.*## / {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

build: ## Build the Nix flake
	nix build .

run: ## Run the Nix flake
	nix run .

nvim: ## Sync ./nvim into ~/.config/$(APPNAME) (mirrors deletions)
	mkdir -p "${HOME}/.config/$(APPNAME)"
	rsync -a --delete ./nvim/ "${HOME}/.config/$(APPNAME)/"

nvim-dev: ## Same as nvim, but installs to ~/.config/kokovim-dev
	$(MAKE) nvim APPNAME=kokovim-dev
