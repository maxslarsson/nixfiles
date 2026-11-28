{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      # nvim-treesitter shells out to the CLI to compile parsers
      home.packages = [ pkgs.tree-sitter ];

      programs.neovim = {
        enable = true;
        defaultEditor = true;
        withPython3 = false;
        withRuby = false;
      };

      xdg.configFile.nvim = {
        source = ./nvim;
        recursive = true;
      };
    };
}
