{
  description = "NixOS WSL";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-21.11/nixexprs.tar.xz";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { self, nixpkgs, home-manager, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        ./defaultUser.nix
        home-manager.nixosModules.home-manager {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
          };
        }
      ];
      specialArgs = { inherit nixpkgs; };
    };
  };
}
