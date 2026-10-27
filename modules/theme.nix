# Single source of truth for the system colour scheme (Evergarden).
# Upstream palettes: https://github.com/everviolet/nvim (lua/evergarden/palettes)
#
# Switch the WHOLE system between light and dark by changing `variant` below:
#   "summer" -> Evergarden Summer (light)
#   "winter" -> Evergarden Winter (dark)
#
# Every module receives the active palette as the `theme` argument
# (via `_module.args`), e.g. `theme.red`, `theme.base`, `theme.green`.
# The file is a plain module, so it can be imported by home-manager AND by a
# NixOS host (machines/elliot/desktop.nix does, to pick GNOME's light/dark).
#
# Ghostty is the exception: it auto-switches with the OS appearance
# (macOS appearance / GNOME colour-scheme) between the two custom themes
# generated below, so `variant` only pins the CLI tools (bat/yazi/eza/fzf/starship).
{ lib, ... }:
let
  # <<< change this one line to reskin everything CLI >>>
  variant = "summer";

  palettes = {
    # Evergarden Summer (light)
    summer = {
      red = "#c58687";
      orange = "#c69883";
      yellow = "#c4aa80";
      lime = "#abb182";
      green = "#91a77a";
      aqua = "#74a48b";
      skye = "#719f96";
      snow = "#7799a3";
      blue = "#8294ad";
      purple = "#a897b8";
      pink = "#c499b8";
      cherry = "#c29fb2";
      text = "#2b3034";
      subtext1 = "#455355";
      subtext0 = "#576869";
      overlay2 = "#707d76";
      overlay1 = "#829084";
      overlay0 = "#acb5a4";
      surface2 = "#ceccbd";
      surface1 = "#e6e1d3";
      surface0 = "#ede8dd";
      base = "#f5efe6";
      mantle = "#f2eae1";
      crust = "#e8ded5";
    };

    # Evergarden Winter (dark)
    winter = {
      red = "#f57f82";
      orange = "#f7a182";
      yellow = "#f5d098";
      lime = "#dbe6af";
      green = "#cbe3b3";
      aqua = "#b3e3ca";
      skye = "#b3e6db";
      snow = "#afd9e6";
      blue = "#b2caed";
      purple = "#d2bdf3";
      pink = "#f3c0e5";
      cherry = "#fae6ef";
      text = "#f8f9e8";
      subtext1 = "#adc9bc";
      subtext0 = "#96b4aa";
      overlay2 = "#839e9a";
      overlay1 = "#6f8788";
      overlay0 = "#58686d";
      surface2 = "#4a585c";
      surface1 = "#374145";
      surface0 = "#262f33";
      base = "#1e2528";
      mantle = "#191e21";
      crust = "#171c1f";
    };
  };

  isDark = variant == "winter";
  eg = palettes.${variant};

  # Ghostty theme (16-colour ANSI palette + UI colours) for a palette.
  # ANSI black/white follow the usual light/dark conventions so "black" text
  # stays readable on Summer and "white" text on Winter.
  mkGhosttyTheme =
    dark: c:
    let
      black = if dark then c.surface1 else c.subtext1;
      brightBlack = if dark then c.surface2 else c.subtext0;
      white = if dark then c.subtext1 else c.surface2;
      brightWhite = if dark then c.text else c.surface1;
    in
    {
      palette = [
        "0=${black}"
        "1=${c.red}"
        "2=${c.green}"
        "3=${c.yellow}"
        "4=${c.blue}"
        "5=${c.purple}"
        "6=${c.aqua}"
        "7=${white}"
        "8=${brightBlack}"
        "9=${c.red}"
        "10=${c.lime}"
        "11=${c.yellow}"
        "12=${c.blue}"
        "13=${c.pink}"
        "14=${c.skye}"
        "15=${brightWhite}"
      ];
      background = c.base;
      foreground = c.text;
      cursor-color = c.green; # Evergarden's accent
      cursor-text = c.base;
      selection-background = c.surface1;
      selection-foreground = c.text;
    };

  # btop theme, generated from a palette. Gradients run cool to hot the way
  # btop's own themes do: green for healthy, yellow for busy, red for hot.
  # `free` and `available` are inverted, because low is the bad end there.
  mkBtopTheme =
    dark: c:
    let
      kv = lib.mapAttrsToList (k: v: ''theme[${k}]="${v}"'');
      # Text drawn on top of a palette colour (the follow and banner chips).
      # Evergarden's accents are mid pastels either way, so the darkest
      # neutral reads best on them in both variants.
      onAccent = if dark then c.crust else c.text;
    in
    lib.concatStringsSep "\n" (kv {
      main_bg = c.base;
      main_fg = c.text;
      title = c.text;
      hi_fg = c.green; # Evergarden's accent
      selected_bg = c.surface1;
      selected_fg = c.text;
      inactive_fg = c.overlay0;
      graph_text = c.subtext0;
      meter_bg = c.surface0;
      proc_misc = c.aqua;

      cpu_box = c.overlay0;
      mem_box = c.overlay0;
      net_box = c.overlay0;
      proc_box = c.overlay0;
      div_line = c.surface2;

      temp_start = c.green;
      temp_mid = c.yellow;
      temp_end = c.red;

      cpu_start = c.green;
      cpu_mid = c.yellow;
      cpu_end = c.red;

      used_start = c.green;
      used_mid = c.yellow;
      used_end = c.red;

      free_start = c.red;
      free_mid = c.yellow;
      free_end = c.green;

      available_start = c.red;
      available_mid = c.yellow;
      available_end = c.green;

      cached_start = c.blue;
      cached_mid = c.aqua;
      cached_end = c.green;

      download_start = c.green;
      download_mid = c.aqua;
      download_end = c.blue;

      upload_start = c.yellow;
      upload_mid = c.orange;
      upload_end = c.pink;

      process_start = c.green;
      process_mid = c.pink;
      process_end = c.red;

      # Process list: follow mode, the paused marker and the banner.
      followed_bg = c.blue;
      followed_fg = onAccent;
      proc_follow_bg = c.blue;
      proc_pause_bg = c.red;
      proc_banner_bg = c.purple;
      proc_banner_fg = onAccent;
    })
    + "\n";

  # Minimal Evergarden tmTheme, generated from the active palette. Used by bat
  # (`--theme`) and yazi (`syntect_theme`) for syntax-highlighted previews.
  # Role assignments mirror upstream lua/evergarden/theme.lua:
  #   keyword=red  string=lime  constant=pink  func=green  type=yellow
  #   property=skye  operator=subtext0  delimiter=overlay1  comment=overlay2
  tmTheme = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>name</key>
      <string>Evergarden ${variant}</string>
      <key>settings</key>
      <array>
        <dict>
          <key>settings</key>
          <dict>
            <key>background</key><string>${eg.base}</string>
            <key>foreground</key><string>${eg.text}</string>
            <key>caret</key><string>${eg.green}</string>
            <key>invisibles</key><string>${eg.overlay0}</string>
            <key>lineHighlight</key><string>${eg.surface0}</string>
            <key>selection</key><string>${eg.surface1}</string>
          </dict>
        </dict>
        <dict>
          <key>scope</key><string>comment, punctuation.definition.comment</string>
          <key>settings</key><dict><key>foreground</key><string>${eg.overlay2}</string></dict>
        </dict>
        <dict>
          <key>scope</key><string>string, string.quoted, constant.character, punctuation.definition.string</string>
          <key>settings</key><dict><key>foreground</key><string>${eg.lime}</string></dict>
        </dict>
        <dict>
          <key>scope</key><string>constant.numeric, constant.language, constant.other</string>
          <key>settings</key><dict><key>foreground</key><string>${eg.pink}</string></dict>
        </dict>
        <dict>
          <key>scope</key><string>keyword, keyword.control, storage, storage.type, storage.modifier</string>
          <key>settings</key><dict><key>foreground</key><string>${eg.red}</string></dict>
        </dict>
        <dict>
          <key>scope</key><string>keyword.operator</string>
          <key>settings</key><dict><key>foreground</key><string>${eg.orange}</string></dict>
        </dict>
        <dict>
          <key>scope</key><string>entity.name.function, support.function, meta.function-call, variable.function</string>
          <key>settings</key><dict><key>foreground</key><string>${eg.green}</string></dict>
        </dict>
        <dict>
          <key>scope</key><string>entity.name.type, entity.name.class, support.type, support.class, entity.other.inherited-class</string>
          <key>settings</key><dict><key>foreground</key><string>${eg.yellow}</string></dict>
        </dict>
        <dict>
          <key>scope</key><string>variable, variable.other, variable.parameter, variable.language, meta.definition.variable</string>
          <key>settings</key><dict><key>foreground</key><string>${eg.text}</string></dict>
        </dict>
        <dict>
          <key>scope</key><string>variable.other.member, variable.other.property, entity.name.tag, support.type.property-name</string>
          <key>settings</key><dict><key>foreground</key><string>${eg.skye}</string></dict>
        </dict>
        <dict>
          <key>scope</key><string>entity.other.attribute-name, meta.annotation, meta.attribute</string>
          <key>settings</key><dict><key>foreground</key><string>${eg.cherry}</string></dict>
        </dict>
        <dict>
          <key>scope</key><string>keyword.operator.assignment, punctuation, meta.brace</string>
          <key>settings</key><dict><key>foreground</key><string>${eg.overlay1}</string></dict>
        </dict>
        <dict>
          <key>scope</key><string>invalid, invalid.illegal</string>
          <key>settings</key><dict><key>foreground</key><string>${eg.red}</string></dict>
        </dict>
        <dict>
          <key>scope</key><string>markup.heading, markup.bold</string>
          <key>settings</key><dict><key>foreground</key><string>${eg.cherry}</string><key>fontStyle</key><string>bold</string></dict>
        </dict>
        <dict>
          <key>scope</key><string>markup.inserted, markup.inserted.diff</string>
          <key>settings</key><dict><key>foreground</key><string>${eg.green}</string></dict>
        </dict>
        <dict>
          <key>scope</key><string>markup.deleted, markup.deleted.diff</string>
          <key>settings</key><dict><key>foreground</key><string>${eg.red}</string></dict>
        </dict>
        <dict>
          <key>scope</key><string>markup.changed, markup.changed.diff</string>
          <key>settings</key><dict><key>foreground</key><string>${eg.aqua}</string></dict>
        </dict>
      </array>
    </dict>
    </plist>
  '';
in
{
  _module.args.theme = eg // {
    name = variant;
    inherit isDark palettes tmTheme;
    ghostty = {
      dark = "evergarden-winter";
      light = "evergarden-summer";
      themes = {
        evergarden-summer = mkGhosttyTheme false palettes.summer;
        evergarden-winter = mkGhosttyTheme true palettes.winter;
      };
    };

    # btop has no light/dark switching of its own, so `active` is the one
    # `variant` selects, like the rest of the CLI tools.
    btop = {
      active = "evergarden-${variant}";
      themes = {
        evergarden-summer = mkBtopTheme false palettes.summer;
        evergarden-winter = mkBtopTheme true palettes.winter;
      };
    };
  };
}
