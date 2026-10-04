{
  pkgs,
  lib,
  theme,
  osConfig ? { },
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;

  # Only where there is something to draw on: every mac, and NixOS hosts that
  # run GNOME (elliot). Headless linux (dom) skips the GTK closure entirely.
  hasDesktop = isDarwin || (osConfig.services.desktopManager.gnome.enable or false);

  # macOS: Cmd+S leader. Linux: Ctrl+S leader (zsh runs `stty -ixon`, so
  # Ctrl+S is free). Same mnemonics on both.
  mod = if isDarwin then "cmd" else "ctrl";
  splitKeys = [
    "${mod}+s>z=toggle_split_zoom"
    "${mod}+s>j=goto_split:bottom"
    "${mod}+s>k=goto_split:top"
    "${mod}+s>h=goto_split:left"
    "${mod}+s>l=goto_split:right"
    "${mod}+s>\\=new_split:right"
    "${mod}+s>-=new_split:down"
  ];
in
{
  config = lib.mkIf hasDesktop {
    programs.ghostty = {
      enable = true;
      # macOS: installed manually (cask). Linux: from nixpkgs.
      package = if isDarwin then null else pkgs.ghostty;

      # Evergarden Summer / Winter, generated from modules/theme.nix and written
      # to ~/.config/ghostty/themes/. Ghostty follows the OS appearance (macOS
      # appearance / GNOME colour-scheme via the desktop portal) to pick one.
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

        keybind = splitKeys ++ lib.optionals isDarwin [ "global:cmd+shift+o=toggle_quick_terminal" ];
      }
      // lib.optionalAttrs isDarwin {
        auto-update = "off";
        background-opacity = 0.80;
        background-blur-radius = 30;
        window-colorspace = "display-p3";
        macos-titlebar-style = "tabs";
        quick-terminal-position = "left";
      }
      // lib.optionalAttrs isLinux {
        # GNOME has no window blur, so stay opaque there.
        gtk-single-instance = true;
        window-decoration = "auto";
      };
    };
  };
}
