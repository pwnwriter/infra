{
  pkgs,
  lib,
  theme,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;

  # Rex (superlogical.com/rex) is a closed beta macOS app installed by hand,
  # like Ghostty was. There is no package and no Linux client yet, so this
  # module only writes its config; ghostty.nix still serves elliot.
  #
  # Rex imports Ghostty and iTerm palettes (the `client.theme.import` action),
  # so the Evergarden palettes in modules/theme.nix feed it unchanged. Render
  # one Ghostty-format theme file per palette:
  #   key = value, and one `palette = N=#rrggbb` line per palette entry.
  renderTheme =
    attrs:
    lib.concatStringsSep "\n" (
      lib.concatLists (
        lib.mapAttrsToList (
          k: v: if builtins.isList v then map (entry: "${k} = ${entry}") v else [ "${k} = ${toString v}" ]
        ) attrs
      )
    )
    + "\n";

  themeFiles = lib.mapAttrs' (
    name: t: lib.nameValuePair "rex/themes/${name}" { text = renderTheme t; }
  ) theme.ghostty.themes;

  # Ported from the Ghostty keybinds: cmd+s is a leader, then a vim direction.
  # Action names are the ones the Rex app reports (`rex -C <client> actions`).
  initLua = ''
    -- Managed by nix (modules/terminal/rex.nix). Edits here are overwritten.
    -- Reload after a rebuild with: rex config reload

    -- cmd+s leader, then a vim direction. Note that cmd+s starts a sequence,
    -- so it no longer reaches the terminal on its own.
    rex.bind("cmd+s>z", "pane.zoom")
    rex.bind("cmd+s>h", "pane.focus.left")
    rex.bind("cmd+s>j", "pane.focus.down")
    rex.bind("cmd+s>k", "pane.focus.up")
    rex.bind("cmd+s>l", "pane.focus.right")
    rex.bind("cmd+s>\\", "pane.split.right")
    rex.bind("cmd+s>-", "pane.split.down")
  '';
in
{
  config = lib.mkIf isDarwin {
    xdg.configFile = themeFiles // {
      "rex/init.lua".text = initLua;
    };
  };
}
