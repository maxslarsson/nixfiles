{
  self,
  nix-darwin,
  home-manager,
  ...
}:
{
  "Maxs-MacBook-Pro" = nix-darwin.lib.darwinSystem {
    modules = [
      home-manager.darwinModules.home-manager

      {
        nixpkgs.hostPlatform = "aarch64-darwin";
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;

        # Set Git commit hash for darwin-version.
        system.configurationRevision = self.rev or self.dirtyRev or null;

        home-manager.users.maxlarsson = import ../home-configurations/maxlarsson/home.nix;
      }

      ./Maxs-MacBook-Pro/configuration.nix
    ];
  };
}
