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

  outputs = inputs: {
    darwinConfigurations = import ./darwin-configurations inputs;
    homeConfigurations = import ./home-configurations inputs;
    devShells = import ./dev-shells inputs;
  };
}
