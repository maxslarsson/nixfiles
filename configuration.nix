{ config, inputs, ... }:
{
  # Because I am using Determinate Nixd
  nix.enable = false;
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  # Used for backwards compatibility, read the changelog before changing
  system.stateVersion = 6;

  system.primaryUser = "maxlarsson";
  users.users.maxlarsson = {
    name = "maxlarsson";
    home = "/Users/maxlarsson";
  };

  system.defaults = {
    NSGlobalDomain = {
      InitialKeyRepeat = 10;
      KeyRepeat = 2;
      ApplePressAndHoldEnabled = false;

      AppleInterfaceStyle = "Dark";
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
      PMPrintingExpandedStateForPrint = true;
      PMPrintingExpandedStateForPrint2 = true;
    };
    controlcenter = {
      BatteryShowPercentage = true;
    };
    menuExtraClock = {
      ShowSeconds = true;
    };
    screencapture = {
      disable-shadow = true;
      location = "${config.users.users.maxlarsson.home}/Desktop/Screenshots";
    };
    trackpad = {
      Clicking = true;
    };
    finder = {
      AppleShowAllExtensions = true;
      FXDefaultSearchScope = "SCcf"; # Default to current folder
      FXEnableExtensionChangeWarning = false;
      FXPreferredViewStyle = "Nlsv"; # Default to list view in Finder windows
      FXRemoveOldTrashItems = true; # Remove items in trash after 30 days
      NewWindowTarget = "Home";
      QuitMenuItem = true;
      ShowPathbar = true;
      ShowStatusBar = true;

      ShowExternalHardDrivesOnDesktop = false;
      ShowHardDrivesOnDesktop = false;
      ShowMountedServersOnDesktop = false;
      ShowRemovableMediaOnDesktop = false;
    };
    screensaver = {
      askForPassword = true;
      askForPasswordDelay = 0; # 0 seconds = immediately
    };
    dock = {
      appswitcher-all-displays = true;
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
