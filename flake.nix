{
  description = "maxslarsson Nix Files";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
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

      mkHome =
        system: name:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [ ./homeConfigurations/${name}/home.nix ];
        };
    in
    {
      darwinConfigurations = nixpkgs.lib.genAttrs darwinHosts (
        darwinHost:
        nix-darwin.lib.darwinSystem {
          modules = [
            home-manager.darwinModules.home-manager

            {
              nixpkgs.hostPlatform = "aarch64-darwin"; # TODO: Make this work on multiple systems
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              # Set Git commit hash for darwin-version.
              system.configurationRevision = self.rev or self.dirtyRev or null;

              home-manager.users.maxlarsson = import ./homeConfigurations/maxlarsson/home.nix;
            }

            ./darwinConfigurations/${darwinHost}/configuration.nix
          ];
        }
      );

      homeConfigurations = {
        maxlarsson = mkHome "aarch64-darwin" "maxlarsson";
        mlarsson = mkHome "x86_64-linux" "mlarsson";
      };

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
