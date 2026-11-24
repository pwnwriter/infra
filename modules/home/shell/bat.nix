{ pkgs, theme, ... }:
{
  programs.bat = {
    enable = true;

    config = {
      pager = "less -FR";
      theme = "evergarden";
    };

    # Evergarden theme generated from the active palette (see theme.nix).
    themes.evergarden = {
      src = pkgs.writeTextDir "evergarden.tmTheme" theme.tmTheme;
      file = "evergarden.tmTheme";
    };
  };

  home.sessionVariables = {
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    MANROFFOPT = "-c";
  };
}
