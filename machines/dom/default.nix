{ inputs }:
(import ../lib.nix { inherit inputs; }).mkHome {
  username = "eipi";
  homeDirectory = "/home/eipi";
}
