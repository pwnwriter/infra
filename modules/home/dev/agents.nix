{ pkgs, ... }:
{
  # Coding agents.
  #
  # codex comes from llm-agents.nix rather than nixpkgs, which tracks OpenAI's
  # releases daily and so runs well ahead of the nixpkgs copy. codex-acp is the
  # Agent Client Protocol adapter: it fronts the Codex App Server so GUI
  # clients that speak ACP can drive the same agent.
  home.packages = [
    pkgs.claude-code
    pkgs.antigravity-cli
    pkgs.llm-agents.codex
    pkgs.llm-agents.codex-acp
  ];
}
