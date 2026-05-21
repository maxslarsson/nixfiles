{ nixpkgs, home-manager, ... }:
{
  maxlarsson = home-manager.lib.homeManagerConfiguration {
    pkgs = import nixpkgs { system = "aarch64-darwin"; };
    modules = [ ./maxlarsson/home.nix ];
  };

  mlarsson = home-manager.lib.homeManagerConfiguration {
    pkgs = import nixpkgs { system = "x86_64-linux"; };
    modules = [ ./mlarsson/home.nix ];
  };
}
