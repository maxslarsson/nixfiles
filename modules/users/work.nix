{ config, ... }:
{
  configurations.home.work = {
    system = "x86_64-linux";
    module = {
      imports = [ config.flake.modules.homeManager.base ];

      home = {
        # Read the Home Manager release notes before changing
        stateVersion = "25.05";
        username = "mlarsson";
        homeDirectory = "/home/mlarsson";

        sessionPath = [
          "$HOME/go/bin"
          "$HOME/.local/share/dx/bin"
        ];

        # Bedrock requires this for auto permission mode to be available
        sessionVariables.CLAUDE_CODE_ENABLE_AUTO_MODE = 1;
      };
    };
  };
}
