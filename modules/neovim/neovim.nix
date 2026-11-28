{
  flake.modules.homeManager.base =
    { config, pkgs, ... }:
    {
      # nvim-treesitter shells out to the CLI to compile parsers
      home.packages = [ pkgs.tree-sitter ];

      programs.neovim = {
        enable = true;
        defaultEditor = true;
        withPython3 = false;
        withRuby = false;
        # init.lua can't be written into the out-of-store link below
        sideloadInitLua = true;
        # The tree-sitter CLI calls cc to compile parsers; telescope-fzf-native builds with make
        extraPackages = with pkgs; [
          stdenv.cc
          gnumake
        ];
      };

      # Edits apply without a rebuild; assumes the repo is at ~/dev/nixfiles
      # The path must match this directory: moving or renaming it silently breaks ~/.config/nvim
      xdg.configFile.nvim.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dev/nixfiles/modules/neovim/nvim";
    };
}
