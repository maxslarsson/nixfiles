{ config, ... }:
{
  configurations.home.work = {
    system = "x86_64-linux";
    module =
      { pkgs, ... }:
      {
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

          packages = with pkgs; [
            nixos-rebuild-ng
            (python3.withPackages (
              ps: with ps; [
                ipython
                pypdf
                cryptography
              ]
            ))

            # Ubuntu does not ship with these by default
            stdenv.cc
            gnumake
          ];
        };
      };
  };
}
