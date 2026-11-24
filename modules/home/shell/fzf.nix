{ theme, ... }:
{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;

    # Evergarden colours from the active palette (see theme.nix).
    colors = {
      "fg" = theme.subtext0;
      "bg" = theme.base;
      "hl" = theme.orange;
      "fg+" = theme.text;
      "bg+" = theme.surface1;
      "hl+" = theme.orange;
      "border" = theme.surface1;
      "header" = theme.green;
      "gutter" = theme.base;
      "spinner" = theme.yellow;
      "info" = theme.aqua;
      "separator" = theme.surface1;
      "pointer" = theme.purple;
      "marker" = theme.red;
      "prompt" = theme.subtext0;
    };
  };
}
