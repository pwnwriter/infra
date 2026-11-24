{ pkgs, ... }:
let
  identity = import ./identity.nix;
in
{
  programs.git = {
    enable = true;

    ignores = [ ".DS_Store" ];

    settings = {
      user = {
        inherit (identity) name email;
      };

      pull.rebase = true;

      credential.helper = if pkgs.stdenv.isDarwin then "osxkeychain" else "cache";

      help.autocorrect = 5;

      alias = {
        cl = "clone --depth=1 --filter=blob:none";
      };
    };

    signing = {
      key = identity.signingKey;
      signByDefault = pkgs.stdenv.isDarwin;
    };
  };
}
