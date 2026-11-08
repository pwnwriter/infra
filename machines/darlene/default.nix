{ inputs }:
(import ../../lib { inherit inputs; }).mkDarwin {
  modules = [
    { services.tailscale.enable = true; }
    ./always-on.nix
    # Mac Mini specific settings
    {
      system.keyboard.enableKeyMapping = true;
      system.keyboard.swapLeftCommandAndLeftAlt = true;
    }
  ];
}
