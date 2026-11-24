{ inputs }:
let
  inherit (inputs)
    nixpkgs
    home-manager
    darwin
    agenix
    determinate
    ;

  # Agent packages (codex, codex-acp, chatgpt, ...) built against our own
  # nixpkgs, so they share its dependencies and honour allowUnfree.
  overlays = [ inputs.llm-agents.overlays.shared-nixpkgs ];

  # Shared home-manager wiring for system-integrated hosts (darwin / nixos).
  # home.stateVersion is owned by modules/home/default.nix.
  hmModule = username: {
    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
      users.${username}.imports = [
        ../modules/home
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
        {
          nixpkgs.config.allowUnfree = true;
          nixpkgs.overlays = overlays;
        }
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
        {
          nixpkgs.config.allowUnfree = true;
          nixpkgs.overlays = overlays;
        }
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
        inherit overlays;
        config.allowUnfree = true;
      };
      modules = [
        ../modules/home
        agenix.homeManagerModules.default
        { home = { inherit username homeDirectory; }; }
      ];
    };
}
