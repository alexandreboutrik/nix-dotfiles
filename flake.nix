{
  description = "Boutrik's Flake configuration for multiple hosts";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };

  outputs = { self, nixpkgs, home-manager, nix-flatpak, ... }@inputs: {
    nixosConfigurations = {
      # Dell Rugged 5424
      d5424 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          ./hardware/d5424.nix
          home-manager.nixosModules.home-manager
          nix-flatpak.nixosModules.nix-flatpak
        ];
      };

      # ThinkPad T480
      t480 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          ./hardware/t480.nix
          home-manager.nixosModules.home-manager
          nix-flatpak.nixosModules.nix-flatpak
        ];
      };
    };
  };
}
