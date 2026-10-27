{
  pkgs,
  lib,
  theme,
  osConfig ? { },
  ...
}:
let
  # Linux only, and only where there is something to draw on: elliot's GNOME
  # session, which runs a fullscreen Ghostty as its btm dashboard (see
  # machines/elliot/desktop.nix). Headless linux (dom) skips the GTK closure.
  #
  # The macs moved to Rex (see ./rex.nix), which has no Linux client yet.
  hasDesktop =
    pkgs.stdenv.hostPlatform.isLinux && (osConfig.services.desktopManager.gnome.enable or false);
in
{
  config = lib.mkIf hasDesktop {
    programs.ghostty = {
      enable = true;
      package = pkgs.ghostty;

      # Evergarden Summer / Winter, generated from modules/theme.nix and written
      # to ~/.config/ghostty/themes/. Ghostty follows the GNOME colour-scheme
      # (via the desktop portal) to pick one.
      themes = theme.ghostty.themes;

      settings = {
        shell-integration = "zsh";
        shell-integration-features = "no-cursor,sudo,no-title";

        theme = "dark:${theme.ghostty.dark},light:${theme.ghostty.light}";

        font-family = "Lilex Nerd Font Mono Medium";
        window-padding-x = "40,40";
        window-padding-y = "20,30";
        window-subtitle = "false";
        mouse-hide-while-typing = true;

        # GNOME has no window blur, so stay opaque there.
        gtk-single-instance = true;
        window-decoration = "auto";

        # ctrl+s leader (zsh runs `stty -ixon`, so ctrl+s is free).
        keybind = [
          "ctrl+s>z=toggle_split_zoom"
          "ctrl+s>j=goto_split:bottom"
          "ctrl+s>k=goto_split:top"
          "ctrl+s>h=goto_split:left"
          "ctrl+s>l=goto_split:right"
          "ctrl+s>\\=new_split:right"
          "ctrl+s>-=new_split:down"
        ];
      };
    };
  };
}
