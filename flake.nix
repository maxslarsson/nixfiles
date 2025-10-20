{
  description = "maxslarsson Nix Files";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
    }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forEachSupportedSystem =
        f:
        nixpkgs.lib.genAttrs supportedSystems (
          system:
          f {
            pkgs = import nixpkgs { inherit system; };
          }
        );

      darwinHosts = builtins.attrNames (builtins.readDir ./darwinConfigurations);
      darwinConfigurations = nixpkgs.lib.genAttrs darwinHosts (
        darwinHost:
        nix-darwin.lib.darwinSystem {
          modules = [
            {
              nixpkgs.hostPlatform = "aarch64-darwin"; # TODO: Make this work on multiple systems
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
            }

            ./darwinConfigurations/${darwinHost}/configuration.nix
          ];

          specialArgs = {
            inherit
              self
              nixpkgs
              nix-darwin
              home-manager
              ;
          };
        }
      );

      homeUsers = builtins.attrNames (builtins.readDir ./homeConfigurations);
      homeConfigurations = nixpkgs.lib.genAttrs homeUsers (
        homeUser:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-darwin; # TODO: Make this work on multiple systems

          modules = [
            ./homeConfigurations/${homeUser}/home.nix
          ];
        }
      );
    in
    {
      darwinConfigurations = darwinConfigurations;
      homeConfigurations = homeConfigurations;

      devShells = forEachSupportedSystem (
        { pkgs }:
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              lua-language-server
            ];
          };
        }
      );
    };
}
