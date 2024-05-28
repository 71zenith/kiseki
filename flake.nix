{
  description = "Nix Flake for Zen";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    neorg = {
      url = "github:nvim-neorg/nixpkgs-neorg-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    prismlauncher = {
      url = "github:julcioo/PrismLauncher-Cracked?ref=8.3-cracked";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dvd-zig = {
      url = "github:71zenith/dvd-zig";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland?ref=v0.39.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-colors.url = "github:misterio77/nix-colors";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };
  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    pcName = "izanagi";
    myUserName = "zen";
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
    caches = {
      nix.settings = {
        builders-use-substitutes = true;
        substituters = [
          "https://cache.garnix.io"
          "https://hyprland.cachix.org"
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"
          "https://nixpkgs-wayland.cachix.org"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
          "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        ];
      };
    };
    overlays = {
      nixpkgs.overlays = [
        inputs.hyprland.overlays.default
        inputs.neorg.overlays.default
      ];
    };
  in {
    devShell.${system} = pkgs.mkShell {
      packages = with pkgs; [lolcat];
      shellHook = ''
        printf "\e[3m\e[1m%s\em\n" "1337 h4x0ring..." | lolcat
      '';
    };
    nixosConfigurations.${pcName} = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        inherit pcName;
        inherit myUserName;
      };
      modules = [
        caches
        overlays
        inputs.stylix.nixosModules.stylix
        inputs.nur.nixosModules.nur
        inputs.home-manager.nixosModules.default
        inputs.sops-nix.nixosModules.sops
        ./hosts/izanagi/nixos/config.nix
      ];
    };
  };
}
