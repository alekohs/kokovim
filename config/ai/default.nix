{
  imports = [
    ./copilot-chat.nix
    ./code-companion.nix
  ];

  plugins.copilot-lua = {
    enable = true;
    lazyLoad.settings.event = [ "DeferredUIEnter" ];
  };
}
