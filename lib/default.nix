{ inputs }:
let
  inherit (inputs)
    nixpkgs
    home-manager
    darwin
    agenix
    determinate
    ;

  # Shared home-manager wiring for system-integrated hosts (darwin / nixos).
  # home.stateVersion is owned by modules/default.nix.
  hmModule = username: {
    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
      users.${username}.imports = [
        ../modules
        agenix.homeManagerModules.default
      ];
    };
  };
in
{
  # nix-darwin host (macs)
  mkDarwin =
    {
      system ? "aarch64-darwin",
      username ? "pwnwriter",
      modules ? [ ],
    }:
    darwin.lib.darwinSystem {
      inherit system;
      modules = [
        { nixpkgs.config.allowUnfree = true; }
        ../modules/darwin
        home-manager.darwinModules.home-manager
        (hmModule username)
      ]
      ++ modules;
    };

  # NixOS host
  mkNixos =
    {
      system ? "x86_64-linux",
      username ? "pwn",
      modules ? [ ],
    }:
    nixpkgs.lib.nixosSystem {
      inherit system;
      # Machine modules reach flake inputs through this (see
      # machines/elliot/desktop.nix, which uses the llm-agents overlay).
      specialArgs = { inherit inputs; };
      modules = [
        { nixpkgs.config.allowUnfree = true; }
        determinate.nixosModules.default
        { determinate.enable = true; }
        home-manager.nixosModules.home-manager
        (hmModule username)
      ]
      ++ modules;
    };

  # Standalone home-manager host (linux server)
  mkHome =
    {
      system ? "x86_64-linux",
      username,
      homeDirectory,
    }:
    home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      modules = [
        ../modules
        agenix.homeManagerModules.default
        { home = { inherit username homeDirectory; }; }
      ];
    };
}
