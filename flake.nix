{
  description = "NixOS WSL";

  inputs.nixpkgs.url = "https://channels.nixos.org/nixos-21.11/nixexprs.tar.xz";

  outputs = { self, nixpkgs }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
      ];
      specialArgs = { inherit nixpkgs; };
    };
  };
}
