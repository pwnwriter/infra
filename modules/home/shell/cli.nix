{ pkgs, ... }:
{
  # General CLI tools. bat / btop / eza / fastfetch / zoxide are intentionally absent —
  # their programs.* modules in this dir install them.
  home.packages = with pkgs; [
    aria2
    curlie
    fd
    jnv
    jq
    just
    neovim
    openssl
    pkg-config
    ripgrep
    typst
    uv
    tree-sitter
    statix
  ];
}
