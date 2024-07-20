{
  description = "Nix Flake for Zen";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nur.url = "github:nix-community/NUR";
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
      };
    };
    neorg = {
      url = "github:nvim-neorg/nixpkgs-neorg-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
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
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ### MY FLAKES ###
    lem = {
      url = "github:71zenith/lem-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
    dvd-zig = {
      url = "github:71zenith/dvd-zig";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
    my-assets = {
      url = "github:71zenith/assets";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
    scraperwolf = {
      url = "github:71zenith/scraperwolf";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };
  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    ### DECLARE USER ###
    pcName = "izanagi";
    myUserName = "zen";
    matrixId = "@mori.zen:matrix.org";
    mailId = "71zenith@proton.me";

    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};

    # HACK: nur prevent infinite recursion
    nurNoPkgs = import inputs.nur {
      nurpkgs = import nixpkgs {inherit system;};
    };

    caches = {
      nix.settings = {
        builders-use-substitutes = true;
        substituters = [
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"
          "https://cache.garnix.io"
          "https://nix-gaming.cachix.org"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
          "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        ];
      };
    };
    overlays = {
      nixpkgs.overlays = with inputs; [
        prismlauncher.overlays.default
        neorg.overlays.default
        dvd-zig.overlays.default
        my-assets.overlays.default
        lem.overlays.default
        scraperwolf.overlays.default
        (import ./pkgs)
      ];
    };
  in {
    devShell.${system} = pkgs.mkShell {
      packages = with pkgs; [lolcat alejandra nil];
      shellHook = ''
        printf "\e[3m\e[1m%s\em\n" "1337 h4x0ring..." | lolcat
      '';
    };
    nixosConfigurations.${pcName} = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs nurNoPkgs;
        inherit pcName myUserName matrixId mailId;
      };
      modules = with inputs; [
        caches
        overlays
        stylix.nixosModules.stylix
        nur.nixosModules.nur
        home-manager.nixosModules.home-manager
        sops-nix.nixosModules.sops
        flake-programs-sqlite.nixosModules.programs-sqlite
        (import ./nixos/config.nix)
      ];
    };
  };
}
