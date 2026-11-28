{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.gh ];

      programs.git = {
        enable = true;
        lfs.enable = true;

        settings = {
          pull.rebase = true;
          rebase.autoStash = true;
          rerere.enabled = true;
          merge.tool = "nvimdiff";

          # Sign commits with an SSH key. user.signingkey is set in per-machine config
          gpg.format = "ssh";
          commit.gpgsign = true;
          tag.gpgsign = true;
        };

        ignores = [
          ".direnv"
          ".envrc"
          ".DS_Store"
          "ehthumbs.db"
          "Icon\r\r"
          "Thumbs.db"
        ];
      };

      programs.lazygit.enable = true;
    };
}
