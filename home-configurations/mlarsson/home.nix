{ ... }:
{
  imports = [ ../common ];

  home = {
    username = "mlarsson";
    homeDirectory = "/home/mlarsson";

    sessionPath = [
      "$HOME/go/bin"
      "$HOME/.local/share/dx/bin"
    ];
  };
}
