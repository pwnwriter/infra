{ theme, ... }:
{
  programs.btop = {
    enable = true;

    # Evergarden Summer / Winter, generated from the active palette
    # (see modules/theme.nix). btop has no light/dark switching of its own,
    # so `variant` there picks which one is selected below.
    themes = theme.btop.themes;

    settings = {
      color_theme = theme.btop.active;
      theme_background = true;
      truecolor = true;
      vim_keys = true;
    };
  };
}
