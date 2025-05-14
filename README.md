Inspiration https://github.com/aorith/neovim-flake/blob/master/README.md

### Debug
Check some of the paths
```` bash
nix run . -- --headless -c 'echo stdpath("config") | q'
nix run . -- --headless -c 'echo &runtimepath | q'
nix run . -- --headless -c 'echo &packpath | q'
nix run . -- --headless -c 'echo $XDG_CONFIG_HOME | q'
``

