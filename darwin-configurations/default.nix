{ nix-darwin, home-manager, ... }@inputs:
{
  "Maxs-MacBook-Pro" = nix-darwin.lib.darwinSystem {
    specialArgs = { inherit inputs; };
    modules = [
      home-manager.darwinModules.home-manager
      ./Maxs-MacBook-Pro/configuration.nix
    ];
  };
}
