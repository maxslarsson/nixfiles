{ config, pkgs, ... }:
{
  # Because I am using Determinate Nixd
  nix.enable = false;

  # Used for backwards compatibility, read the changelog before changing
  system.stateVersion = 6;

  system.primaryUser = "maxlarsson";
  users.users.maxlarsson = {
    name = "maxlarsson";
    home = "/Users/maxlarsson";
  };

  homebrew = {
    enable = true;
    taps = builtins.attrNames (config.nix-homebrew.taps);
    casks = [
      "ghostty" # This is only required since the nixpkgs.ghostty is broken on Darwin
    ];
  };

  system.defaults = {
    NSGlobalDomain = {
      InitialKeyRepeat = 10;
      KeyRepeat = 2;
      ApplePressAndHoldEnabled = false;
    };
    screensaver = {
      askForPassword = true;
      askForPasswordDelay = 0; # 0 seconds = immediately
    };
    dock = {
      orientation = "right";
      tilesize = 16;
      autohide = true;
      persistent-apps = [ ];
      persistent-others = [ ];
      show-process-indicators = false;
      show-recents = false;
    };
  };

  # Enable Touch ID authentication for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  programs = {
    zsh.enable = true;
    fish.enable = true;
  };
}
