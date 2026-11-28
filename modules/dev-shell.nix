{
  perSystem =
    { pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        packages = [ pkgs.lua-language-server ];
      };
    };
}
