{
  config,
  pkgs,
  lib,
  ...
}:
let
  repoDir = "${config.home.homeDirectory}/Developer/infra";
in
{
  config = lib.mkIf pkgs.stdenv.isLinux {
    home.packages = [ pkgs.herdr ];

    xdg.configFile."herdr/config.toml".source =
      config.lib.file.mkOutOfStoreSymlink "${repoDir}/modules/home/terminal/herdr/config.toml";
  };
}
