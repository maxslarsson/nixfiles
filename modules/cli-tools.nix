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

        nixd
        nixfmt
        nix-output-monitor

        claude-code
        codex
        antigravity-cli
      ];

      programs = {
        ripgrep.enable = true;
        fd.enable = true;
        fzf.enable = true;
        bat.enable = true;
        nh.enable = true;
      };
    };
}
