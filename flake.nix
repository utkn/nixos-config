{
  description = "Some NixOS config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Plasma manager
    plasma-manager.url = "github:pjones/plasma-manager";
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.inputs.home-manager.follows = "home-manager";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @inputs: 
  let
    inherit (self) outputs;
    system = "x86_64-linux";
    hostName = "apollo";
    adminUser = "utkn";
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      ${hostName} = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs hostName adminUser;};
        # > Our main nixos configuration file <
        modules = [./nixos/configuration.nix];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      ${adminUser} = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system}; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs; userName = adminUser;};
        # > Our main home-manager configuration file <
        modules = [./home-manager/home.nix];
      };
    };
  };
}
