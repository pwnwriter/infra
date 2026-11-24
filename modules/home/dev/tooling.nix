{ pkgs, ... }:
{
  # Compilers, formatters, and language servers used across editors.
  home.packages = with pkgs; [
    # dev tooling
    clang
    nixfmt
    stylua

    # language servers
    lua-language-server
    bash-language-server
    nixd
    tinymist
  ];
}
