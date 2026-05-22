{ pkgs, ... }:
let
  confluence-cli = pkgs.callPackage ./confluence-cli.nix { };
in
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
      confluence-cli
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
