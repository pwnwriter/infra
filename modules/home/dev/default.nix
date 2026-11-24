{
  # NOTE: identity.nix is data (name/email/key), imported directly by
  # git.nix and jj.nix — it is deliberately NOT a module import here.
  imports = [
    ./git.nix
    ./jj.nix
    ./languages.nix
    ./tooling.nix
    ./agents.nix
  ];
}
