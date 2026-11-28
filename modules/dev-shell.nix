{
  perSystem =
    { config, pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        packages = [
          pkgs.lua-language-server
          config.treefmt.build.wrapper
        ];
      };
    };
}
