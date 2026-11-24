{
  pkgs,
  lib,
  theme,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;

  # Rex (superlogical.com/rex) is a closed beta macOS app installed by hand,
  # like Ghostty was before it. There is no package and no Linux client yet,
  # so this module only writes its config.
  #
  # Rex imports Ghostty and iTerm palettes (the `client.theme.import` action),
  # so the Evergarden palettes in theme.nix feed it unchanged. Render
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
  ) theme.terminalThemes.themes;

  # Ported from the Ghostty keybinds: cmd+s is a leader, then a vim direction.
  # Action names are the ones the Rex app reports (`rex -C <client> actions`).
  initLua = ''
    -- Managed by nix (rex.nix). Edits here are overwritten.
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

    -- typeui: say what you want, get the command. OpenAI writes it, Jev judges
    -- it. The plugin lives in the working tree, so only this block needs a
    -- rebuild; editing it afterwards just needs `rex config reload`.
    --
    -- Keys come from .env beside the plugin; nothing to set up here.
    local typeui = os.getenv("HOME") .. "/Developer/typeui.rex/lua"
    package.path = typeui .. "/?.lua;" .. typeui .. "/?/init.lua;" .. package.path

    -- Forget the loaded modules first, so `rex config reload` picks up edits in
    -- the working tree even if the Lua state outlives the reload.
    for name in pairs(package.loaded) do
      if name:match("^typeui") then package.loaded[name] = nil end
    end

    require("typeui").setup{}

    rex.bind("cmd+s>t", "typeui")
  '';
in
{
  config = lib.mkIf isDarwin {
    # Rex never puts its CLI on PATH. Inside a block it exports REX_BIN_DIR and
    # leaves the rest to you; outside one there is nothing at all, because a Mac
    # app cannot write to /usr/local/bin without admin. This wrapper prefers the
    # auto-updating install under Application Support, so it follows the app's
    # own updates, and it is a script rather than a symlink because that path
    # has spaces in it.
    home.packages = [
      (pkgs.writeShellScriptBin "rex" ''
        for candidate in \
          "$HOME/Library/Application Support/com.superlogical.rex/RexServer/Versions/Current/Rex Server.app/Contents/MacOS/rex" \
          "/Applications/Rex Beta.app/Contents/Helpers/Rex Server.rex/Contents/MacOS/rex" \
          "/Applications/Rex.app/Contents/Helpers/Rex Server.rex/Contents/MacOS/rex"
        do
          [ -x "$candidate" ] && exec "$candidate" "$@"
        done
        echo "rex: no Rex install found (is the app installed?)" >&2
        exit 1
      '')
    ];

    xdg.configFile = themeFiles // {
      "rex/init.lua".text = initLua;
    };
  };
}
