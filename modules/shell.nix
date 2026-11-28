{
  flake.modules.darwin.base.programs = {
    zsh.enable = true;
    fish.enable = true;
  };

  flake.modules.homeManager.base =
    { lib, pkgs, ... }:
    {
      home.file.".hushlogin".text = "";

      programs.fish = {
        enable = true;
        interactiveShellInit = ''
          set fish_greeting # Disable greeting
          set -g fish_key_bindings fish_vi_key_bindings # Enable VIM keybinds
          set -g fish_color_command green
          set -g fish_color_error red
        '';
        shellAbbrs = {
          c = "clear";
          l = "ls -alh";
          v = "nvim";
          gg = "lazygit";
        };
        functions.mdcd = "mkdir -p $argv; and cd $argv[-1]";
        plugins = with pkgs.fishPlugins; [
          # Gruvbox theme
          {
            name = "gruvbox";
            src = gruvbox.src;
          }
          # Prompt
          {
            name = "tide";
            src = tide.src;
          }
          # Z dir jumping
          {
            name = "z";
            src = z.src;
          }
          # FZF
          {
            name = "fzf";
            src = fzf-fish.src;
          }
        ];
      };

      # Apply the Tide prompt config non-interactively on every rebuild.
      # `tide` is a fish function (not a $PATH program) and activation runs in
      # bash, so it must be invoked via `fish -c`. `--auto` writes every Tide
      # universal variable. `TERM=dumb` keeps Tide's internal `clear` call quiet:
      # activation has no real terminal, so otherwise `clear` errors noisily.
      home.activation.configureTide = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run ${pkgs.fish}/bin/fish -c '
          set -gx TERM dumb
          tide configure --auto \
            --style=Lean \
            --prompt_colors="16 colors" \
            --show_time=No \
            --lean_prompt_height="Two lines" \
            --prompt_connection=Disconnected \
            --prompt_spacing=Compact \
            --icons="Few icons" \
            --transient=Yes
        '
      '';
    };
}
