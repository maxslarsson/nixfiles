{ nixpkgs, ... }:
let
  supportedSystems = [
    "x86_64-linux"
    "aarch64-linux"
    "x86_64-darwin"
    "aarch64-darwin"
  ];

  forEachSupportedSystem =
    f: nixpkgs.lib.genAttrs supportedSystems (system: f (import nixpkgs { inherit system; }));
in
forEachSupportedSystem (pkgs: {
  default = pkgs.mkShell {
    packages = [ pkgs.lua-language-server ];
  };
})
