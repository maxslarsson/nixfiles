{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      fonts.fontconfig.enable = true;
      home.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

      programs.ghostty = {
        enable = true;
        package = null;
        systemd.enable = false;
        enableFishIntegration = true;
        settings = {
          theme = "Gruvbox Dark";
          font-family = "JetBrainsMono Nerd Font Mono";
          font-size = 12;
          keybind = [
            "super+h=goto_split:left"
            "super+j=goto_split:bottom"
            "super+k=goto_split:top"
            "super+l=goto_split:right"
            "shift+enter=text:\\n"
          ];
          command = "${pkgs.fish}/bin/fish --interactive";
          window-padding-color = "extend-always";
          shell-integration-features = "ssh-env";
        };
      };
    };
}
