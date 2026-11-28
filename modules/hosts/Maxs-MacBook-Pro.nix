{ config, inputs, ... }:
{
  flake.darwinConfigurations."Maxs-MacBook-Pro" = inputs.nix-darwin.lib.darwinSystem {
    modules = [ config.flake.modules.darwin."Maxs-MacBook-Pro" ];
  };

  flake.modules.darwin."Maxs-MacBook-Pro" = {
    imports = with config.flake.modules.darwin; [
      base
      maxlarsson
    ];

    # Because I am using Determinate Nixd
    nix.enable = false;
    nixpkgs.config.allowUnfree = true;
    nixpkgs.hostPlatform = "aarch64-darwin";

    # Used for backwards compatibility, read the changelog before changing
    system.stateVersion = 6;

    # Set Git commit hash for darwin-version.
    system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

    system.primaryUser = "maxlarsson";
  };
}
