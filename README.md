Inspiration https://github.com/aorith/neovim-flake/blob/master/README.md

### Configuration
https://github.com/NixOS/nixpkgs/blob/f71ccdc1bc17dffc83a8c49d0aa9ae92644572ab/doc/languages-frameworks/neovim.section.md?plain=1#L3

### Debug
Check some of the paths
```` bash
nix run . -- --headless -c 'echo stdpath("config") | q'
nix run . -- --headless -c 'echo &runtimepath | q'
nix run . -- --headless -c 'echo &packpath | q'
nix run . -- --headless -c 'echo $XDG_CONFIG_HOME | q'
``


### Inspect neovim-unwrapped
```` bash
nix repl
:lf .#nixpkgs
pkgs = inputs.nixpkgs.legacyPackages."x86_64-linux"
pkgs.neovim-unwrapped
``

