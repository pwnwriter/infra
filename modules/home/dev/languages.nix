{ pkgs, ... }:
{
  # Language toolchains (go / rust / zig) and their language servers.
  home.packages = with pkgs; [
    # go
    go
    gopls

    # rust
    rustup
    cargo-watch
    cargo-generate

    # zig
    zig
    zls
  ];
}
