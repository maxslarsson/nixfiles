{ config, inputs, ... }:
{
  flake.modules.homeManager.maxlarsson =
    { pkgs, ... }:
    {
      imports = [ config.flake.modules.homeManager.base ];

      home = {
        # Read the Home Manager release notes before changing
        stateVersion = "25.05";
        username = "maxlarsson";
        homeDirectory = "/Users/maxlarsson";
        packages = with pkgs; [
          (python3.withPackages (ps: [ ps.ipython ]))
        ];
      };

      programs.git.settings.user = {
        name = "Max Larsson";
        email = "maxslarsson@gmail.com";
      };

      programs.ghostty.settings.macos-titlebar-style = "hidden";
    };

  flake.modules.darwin.maxlarsson = {
    users.users.maxlarsson = {
      name = "maxlarsson";
      home = "/Users/maxlarsson";
    };
    home-manager.users.maxlarsson = config.flake.modules.homeManager.maxlarsson;
  };

  flake.homeConfigurations.maxlarsson = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs {
      system = "aarch64-darwin";
      config.allowUnfree = true;
    };
    modules = [ config.flake.modules.homeManager.maxlarsson ];
  };
}
