{
  description = "Some NixOS config =)";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
  };
}
