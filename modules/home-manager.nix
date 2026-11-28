{ inputs, ... }:
{
  flake.modules.darwin.base = {
    imports = [ inputs.home-manager.darwinModules.home-manager ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
    };
  };

  flake.modules.homeManager.base = {
    news.display = "silent";
    xdg.enable = true;

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };
}
