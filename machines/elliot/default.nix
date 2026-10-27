{ inputs }:
(import ../../lib { inherit inputs; }).mkNixos {
  modules = [
    ./hardware.nix
    ./system.nix
    ./nix.nix
    ./power.nix
    ./services.nix
    ./audio.nix
    ./desktop.nix
    ./t3code.nix
  ];
}
