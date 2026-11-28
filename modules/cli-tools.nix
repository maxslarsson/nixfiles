{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        tio
        tree
        htop
        nodejs
        tealdeer
        (python3.withPackages (ps: [ ps.ipython ]))

        nixd
        nixfmt
        nix-output-monitor
        nixos-rebuild-ng

        claude-code
        codex
        antigravity-cli
      ];

      programs = {
        ripgrep.enable = true;
        fd.enable = true;
        fzf = {
          enable = true;
          enableFishIntegration = false;
        };
        atuin = {
          enable = true;
          flags = [ "--disable-up-arrow" ];
        };
        bat.enable = true;
        zoxide.enable = true;
        nh.enable = true;
      };
    };
}
