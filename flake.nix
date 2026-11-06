{
  description = "👻";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";

    # Desktop apps for AI agents (chatgpt, claude-desktop, ...).
    # Its overlay builds against our nixpkgs, so unfree is allowed by our
    # config rather than the flake's own pinned nixpkgs.
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: {
    # macOS (nix-darwin)
    darwinConfigurations = {
      darlene = import ./machines/darlene { inherit inputs; };
      whiterose = import ./machines/whiterose { inherit inputs; };
    };

    # NixOS
    nixosConfigurations = {
      elliot = import ./machines/elliot { inherit inputs; };
    };

    # home-manager (linux)
    homeConfigurations = {
      dom = import ./machines/dom { inherit inputs; };
    };
  };
}
