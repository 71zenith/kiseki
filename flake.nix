{
  description = "crossbell cathedral";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nixpkgs-old.url = "github:nixos/nixpkgs?rev=f601f6b835ff67b95fd34b02163cf4df3b2f86ce";
    flake-utils.url = "github:numtide/flake-utils";
    nix-colors.url = "github:misterio77/nix-colors";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
        flake-utils.follows = "flake-utils";
      };
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    prismlauncher = {
      url = "github:Diegiwg/PrismLauncher-Cracked?ref=v8.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-programs-sqlite = {
      url = "github:wamserma/flake-programs-sqlite";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "flake-utils";
      };
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ### MY FLAKES ###
    assets = {
      url = "github:71zenith/assets";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };
  outputs = {nixpkgs, ...} @ inputs: let
    ### NOTE: DECLARE USER ###
    pcName = "izanagi";
    myUserName = "zen";
    myName = "Mori Zen";
    nixName = pkgs.lib.maintainers._71zenith;
    mailId = "71zenith@proton.me";

    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
    pkgs-old = import inputs.nixpkgs-old {inherit system;};

    caches = {
      nix.settings = {
        builders-use-substitutes = true;
        substituters = [
          "https://cache.nixos.org"
          "https://71zenith.cachix.org"
          "https://nix-community.cachix.org"
          "https://cache.garnix.io"
          "https://nix-gaming.cachix.org"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "71zenith.cachix.org-1:zgsLS/pqOu+HiRod/UxLY7FFfJn4BCw3BgtaTA2wbgg="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
          "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        ];
      };
    };
    overlays = {
      nixpkgs.overlays = with inputs; [
        prismlauncher.overlays.default
        assets.overlays.default
        (import ./pkgs {inherit (nixpkgs) lib;})
      ];
    };
  in {
    devShell.${system} = pkgs.mkShell {
      packages = with pkgs; [lolcat alejandra nil deadnix statix];
      shellHook = ''
        printf "\e[3m\e[1m%s\em\n" "1337 h4x0ring..." | lolcat
      '';
    };
    nixosConfigurations.${pcName} = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs nixName pkgs-old;
        inherit pcName myUserName myName mailId;
      };
      modules = with inputs; [
        caches
        overlays
        stylix.nixosModules.stylix
        home-manager.nixosModules.home-manager
        sops-nix.nixosModules.sops
        flake-programs-sqlite.nixosModules.programs-sqlite
        (import ./nixos/config.nix)
      ];
    };
  };
}
