{
  lib,
  pkgs,
  theme,
  inputs,
  ...
}:
{
  # Pull in the shared palette so GNOME's light/dark choice follows
  # `variant` in modules/theme.nix (summer -> light, winter -> dark).
  imports = [ ../../modules/theme.nix ];

  # Desktop apps for AI agents, built against this system's nixpkgs so they
  # share its dependencies and honour its allowUnfree.
  nixpkgs.overlays = [ inputs.llm-agents.overlays.shared-nixpkgs ];

  # GNOME (Wayland-only since GNOME 49), GDM as the greeter.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Straight into pwn's session on boot: this machine runs with the screen on
  # and nobody at the greeter to log in.
  services.displayManager.autoLogin = {
    enable = true;
    user = "pwn";
  };
  # GDM autologin races getty on tty1 (NixOS/nixpkgs#103746).
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # GNOME turns on power-profiles-daemon, which conflicts with the tlp setup
  # in power.nix. Keep tlp: it owns the AC/battery governor policy here.
  services.power-profiles-daemon.enable = false;

  # Chrome is the browser here, so drop GNOME Web rather than ship two.
  environment.gnome.excludePackages = [ pkgs.epiphany ];

  environment.systemPackages = [
    pkgs.google-chrome
    pkgs.llm-agents.chatgpt # ChatGPT / Codex desktop app
  ];

  # Hand http(s) and html to Chrome instead of whatever GNOME picks.
  xdg.mime.defaultApplications =
    let
      chrome = "google-chrome.desktop";
    in
    {
      "text/html" = chrome;
      "x-scheme-handler/http" = chrome;
      "x-scheme-handler/https" = chrome;
      "x-scheme-handler/about" = chrome;
      "x-scheme-handler/unknown" = chrome;
    };

  # System-wide dconf defaults (user can still override in Settings).
  programs.dconf.profiles.user.databases = [
    {
      settings = {
        # Evergarden: light = Summer, dark = Winter.
        "org/gnome/desktop/interface" = {
          color-scheme = if theme.isDark then "prefer-dark" else "default";
          accent-color = "green"; # Evergarden's accent
        };

        # Screen on 24/7: never blank, dim, lock, or suspend from the session.
        "org/gnome/desktop/session".idle-delay = lib.gvariant.mkUint32 0;
        "org/gnome/desktop/screensaver" = {
          lock-enabled = false;
          idle-activation-enabled = false;
        };
        "org/gnome/desktop/lockdown".disable-lock-screen = true;
        "org/gnome/settings-daemon/plugins/power" = {
          idle-dim = false;
          sleep-inactive-ac-type = "nothing";
          sleep-inactive-battery-type = "nothing";
          power-button-action = "interactive";
        };
      };
    }
  ];
}
