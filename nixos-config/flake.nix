{
  description = "Flake configuration for multiple NixOS machines";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin = {
      url = "github:catppuccin/nix/main";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, catppuccin, ... }: {
    nixosConfigurations = {
      #NOTE: Use your hostname to name each nixosSystem; nix will look for the system's hostname when running 
      # nixos rebuild and will choose the right configuration accordingly

      # Define the configuration for each machine
      nixos-desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/desktop/desktop.nix
          ./configuration.nix
          catppuccin.nixosModules.catppuccin
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.crybot = {
              imports = [
                ./home/default.nix 
                ./hosts/desktop/home.nix
                catppuccin.homeModules.catppuccin
              ];
            };

          }
        ];
      };

      nixos-laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/laptop/laptop.nix
          ./configuration.nix
          catppuccin.nixosModules.catppuccin
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.crybot = {
              imports = [
                ./home/default.nix 
                ./hosts/laptop/home.nix
                catppuccin.homeModules.catppuccin
              ];
            };
          }
        ];
      };
    };
  };
}
