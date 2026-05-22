{ pkgs, ... }:
{
  imports = [ ../common ];

  home = {
    username = "mlarsson";
    homeDirectory = "/home/mlarsson";

    sessionPath = [
      "$HOME/go/bin"
      "$HOME/.local/share/dx/bin"
    ];

    packages = with pkgs; [
      (python3.withPackages (
        ps: with ps; [
          ipython
          pypdf
          cryptography
        ]
      ))
    ];
  };
}
