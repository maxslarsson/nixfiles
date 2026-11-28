{
  flake.modules.homeManager.base =
    { config, ... }:
    {
      programs.direnv = {
        enable = true;
        silent = true;
        nix-direnv.enable = true;
      };

      xdg.configFile."direnv/direnvrc".text = ''
        direnv_layout_dir() {
            local hash path
            hash="$(sha1sum - <<< "$PWD" | head -c40)"
            path="''${PWD//[^a-zA-Z0-9]/-}"
            echo "${config.xdg.cacheHome}/direnv/layouts/''${hash}''${path}"
        }
      '';
    };
}
