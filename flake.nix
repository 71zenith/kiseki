{
  description = "Nix Flake for Zen";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nur.url = "github:nix-community/NUR";
    nix-colors.url = "github:misterio77/nix-colors";
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
    hyprland = {
      url = "github:hyprwm/Hyprland?ref=v0.39.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
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
      url = "github:julcioo/PrismLauncher-Cracked?ref=8.3-cracked";
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
  };
  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    ### DECLARE USER ###
    pcName = "izanagi";
    myUserName = "zen";

    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};

    # HACK: nur prevent infinite recursion
    nur-no-pkgs = import inputs.nur {
      nurpkgs = import nixpkgs {system = "x86_64-linux";};
    };

    caches = {
      nix.settings = {
        builders-use-substitutes = true;
        substituters = [
          "https://cache.nixos.org?priority=10"
          "https://hyprland.cachix.org"
          "https://nix-community.cachix.org"
          "https://nixpkgs-wayland.cachix.org"
          "https://cache.garnix.io"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
          "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        ];
      };
    };
    overlays = {
      nixpkgs.overlays = with inputs; [
        prismlauncher.overlays.default
        hyprland.overlays.default
        neorg.overlays.default
        dvd-zig.overlays.default
        my-assets.overlays.default
        lem.overlays.default
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
        inherit inputs;
        inherit pcName;
        inherit myUserName;
        inherit nur-no-pkgs;
      };
      modules = with inputs; [
        caches
        overlays
        stylix.nixosModules.stylix
        nur.nixosModules.nur
        home-manager.nixosModules.home-manager
        sops-nix.nixosModules.sops
        ./hosts/${pcName}/nixos/config.nix
      ];
    };
  };
}
