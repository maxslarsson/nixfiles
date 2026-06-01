{ nixpkgs, home-manager, ... }:
{
  maxlarsson = home-manager.lib.homeManagerConfiguration {
    pkgs = import nixpkgs {
      system = "aarch64-darwin";
      config.allowUnfree = true;
    };
    modules = [ ./maxlarsson/home.nix ];
  };

  mlarsson = home-manager.lib.homeManagerConfiguration {
    pkgs = import nixpkgs {
      system = "x86_64-linux";
      config.allowUnfree = true;
    };
    modules = [ ./mlarsson/home.nix ];
  };
}
