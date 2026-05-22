{ pkgs, ... }:
{
  imports = [ ../common ];

  home = {
    username = "maxlarsson";
    homeDirectory = "/Users/maxlarsson";
    packages = with pkgs; [
      gh
      claude-code
      tealdeer
      (python3.withPackages (ps: [ ps.ipython ]))
    ];
  };

  programs.git.settings.user = {
    name = "Max Larsson";
    email = "maxslarsson@gmail.com";
  };

  programs.ghostty.settings.macos-titlebar-style = "hidden";
}
