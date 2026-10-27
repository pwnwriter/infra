{ pkgs, ... }:
{
  # Coding agents.
  home.packages = with pkgs; [
    claude-code
    codex
    antigravity-cli
  ];
}
