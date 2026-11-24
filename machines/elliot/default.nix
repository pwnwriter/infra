{ inputs }:
(import ../lib.nix { inherit inputs; }).mkNixos {
  modules = [
    ./hardware.nix
    ./system.nix
    ./nix.nix
    ./power.nix
    ./services.nix
    ./audio.nix
    ./desktop.nix
    ./rex.nix
  ];
}
