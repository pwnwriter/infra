{
  lib,
  pkgs,
  theme,
  ...
}:

let
  macos_prompt = {
    error_symbol = "[ ](red)";
    vimcmd_symbol = "[ ](green)";
    success_symbol = "[ ](orange)";
  };

  linux_prompt = {
    error_symbol = "[ ](red)";
    vimcmd_symbol = "[ ](green)";
    success_symbol = "[ ](orange)";
  };
in
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      scan_timeout = 10;

      # Evergarden palette from the active theme (see theme.nix).
      palette = "evergarden";
      palettes.evergarden = {
        inherit (theme)
          red
          orange
          yellow
          lime
          green
          aqua
          skye
          snow
          blue
          purple
          pink
          cherry
          text
          subtext1
          subtext0
          overlay2
          overlay1
          overlay0
          surface2
          surface1
          surface0
          base
          mantle
          crust
          ;
      };

      format = ''
        $directory$git_branch$git_status
        $character
      '';

      right_format = "$nix_shell";

      character = if pkgs.stdenv.isDarwin then macos_prompt else linux_prompt;

      directory = {
        style = "bold pink";
        truncation_length = 1;
      };

      git_branch = {
        symbol = "󰊢 ";
        format = "on [$symbol$branch]($style) ";
        truncation_length = 4;
        truncation_symbol = "…/";
        style = "bold green";
      };

      git_status = {
        format = "[\\($all_status$ahead_behind\\)]($style) ";
        style = "bold green";
        conflicted = "󱣮";
        up_to_date = " ";
        untracked = " ";
        ahead = "⇡\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        behind = "⇣\${count}";
        stashed = "󰏗 ";
        modified = " ";
        staged = "[++\\($count\\)](green)";
        renamed = "󰖷 ";
        deleted = " ";
      };

      nix_shell = {
        impure_msg = "impure";
        pure_msg = "pure";
        unknown_msg = "unknown";
        format = "[$symbol$state]($style)";
        symbol = " ";
      };
    };
  };

}
