{ inputs }:
(import ../lib.nix { inherit inputs; }).mkDarwin {
  modules = [
    # MacBook-specific: Tailscale client to reach the homelab (dom) from anywhere
    { services.tailscale.enable = true; }
  ];
}
