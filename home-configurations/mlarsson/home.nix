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
      nixos-rebuild-ng
      confluence-cli
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
}
