{
  description = "My personal system configuration.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }@inputs: 
  let
    inherit (nixpkgs) lib;

    # common module for all hosts
    common = [
      home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          #users.gurki = lib.mkMerge [./dotfiles];
        };
      }

      {
        #enable flakes
        nix.settings.experimental-features = [ "nix-command" "flakes" ];
        # Allow unfree packages
        nixpkgs.config.allowUnfree = true;
      }
    ];

    system = "x86_64-linux";

  in {
    nixosConfigurations = {
      gurki-laptop = nixpkgs.lib.nixosSystem {
        system = system;
        modules = [./hosts/laptop.nix] ++ common;
        specialArgs = {
          inherit inputs;
          inherit home-manager;
        };
      };
    };
  };
}
