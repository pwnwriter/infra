{ pkgs, ... }:
let
  identity = import ./identity.nix;
in
{
  programs.jujutsu = {
    enable = true;

    settings = {
      user = {
        inherit (identity) name email;
      };

      signing = {
        backend = "gpg";
        key = identity.signingKey;
        sign-all = pkgs.stdenv.isDarwin;
      };

      ui = {
        default-command = "log";
        editor = "nvim";
        pager = "less -FRX";
        diff.format = "git";
        diff-editor = ":builtin";
        merge-editor = ":builtin";
      };

      # git = {
      #   auto-local-bookmark = true;
      # };

      aliases = {
        d = [ "diff" ];
        s = [ "status" ];
        l = [
          "log"
          "-r"
          "::@"
        ];
        la = [
          "log"
          "-r"
          "all()"
        ];
        f = [
          "git"
          "fetch"
        ];
        p = [
          "git"
          "push"
        ];
      };
    };
  };
}
