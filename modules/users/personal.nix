{ config, ... }:
{
  flake.modules.homeManager.personal = {
    imports = [ config.flake.modules.homeManager.base ];

    home = {
      # Read the Home Manager release notes before changing
      stateVersion = "25.05";
      username = "maxlarsson";
      homeDirectory = "/Users/maxlarsson";
    };

    programs.git.settings.user = {
      name = "Max Larsson";
      email = "maxslarsson@gmail.com";
    };

    programs.ghostty.settings.macos-titlebar-style = "hidden";
  };

  flake.modules.darwin.personal = {
    users.users.maxlarsson = {
      name = "maxlarsson";
      home = "/Users/maxlarsson";
    };
    home-manager.users.maxlarsson = config.flake.modules.homeManager.personal;
  };

  configurations.home.personal = {
    system = "aarch64-darwin";
    module = config.flake.modules.homeManager.personal;
  };
}
