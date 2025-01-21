{
  description = "System and user config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
  };

  outputs = { self, nixpkgs, home-manager, stylix, ... }:   
  let
    system = "x86_64-linux";
    
    pkgs = import nixpkgs {
      inherit system;
      config = { allowUnfree = true; };
    };

    lib = nixpkgs.lib;      

  in {
    nixosConfigurations = {
      nyx = lib.nixosSystem {
        inherit system;

        modules = [
          ./system/configuration.nix
          ./system/hardware-configuration.nix
          stylix.nixosModules.stylix
	  home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.joe = import ./users/joe/home.nix;
 	  }
        ];
      };   
    };
  };
}

