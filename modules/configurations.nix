{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.nix-darwin.flakeModules.default
    inputs.home-manager.flakeModules.default
  ];

  options.configurations = {
    darwin = lib.mkOption {
      type = lib.types.lazyAttrsOf (
        lib.types.submodule {
          options.module = lib.mkOption { type = lib.types.deferredModule; };
        }
      );
    };
    home = lib.mkOption {
      type = lib.types.lazyAttrsOf (
        lib.types.submodule {
          options = {
            system = lib.mkOption { type = lib.types.str; };
            module = lib.mkOption { type = lib.types.deferredModule; };
          };
        }
      );
    };
  };

  config.flake = {
    darwinConfigurations = lib.mapAttrs (
      name:
      { module }:
      inputs.nix-darwin.lib.darwinSystem {
        modules = [
          module
          {
            home-manager.sharedModules = [
              {
                programs.fish.shellAbbrs.update = "git -C ~/dev/nixfiles pull && nh darwin switch ~/dev/nixfiles#${name} --ask";
              }
            ];
          }
        ];
      }
    ) config.configurations.darwin;

    homeConfigurations = lib.mapAttrs (
      name:
      { system, module }:
      inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        modules = [
          module
          {
            programs.fish.shellAbbrs.update = "git -C ~/dev/nixfiles pull && nh home switch ~/dev/nixfiles#${name} --ask";
          }
        ];
      }
    ) config.configurations.home;
  };
}
