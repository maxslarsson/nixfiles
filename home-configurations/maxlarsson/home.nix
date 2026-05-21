{ pkgs, ... }:
{
  imports = [ ../common ];

  home = {
    username = "maxlarsson";
    homeDirectory = "/Users/maxlarsson";
    packages = [ pkgs.claude-code ];
  };

  programs.git.settings.user = {
    name = "Max Larsson";
    email = "maxslarsson@gmail.com";
  };

  programs.ghostty.settings.macos-titlebar-style = "hidden";
}
