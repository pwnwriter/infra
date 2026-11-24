{ config, ... }:
{
  imports = [
    ./theme.nix
    ./fonts.nix
    ./shell
    ./dev
    ./terminal
    ./security
    ./linux.nix
  ];

  xdg.dataHome = "${config.home.homeDirectory}/.local/share";
  programs.home-manager.enable = true;
  home.stateVersion = "26.05";
}
