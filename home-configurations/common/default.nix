{
  config,
  lib,
  pkgs,
  ...
}:
{
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  news.display = "silent";

  xdg = {
    enable = true;
    configFile = {
      "nvim" = {
        source = ./nvim;
        recursive = true;
      };

      "direnv/direnvrc".text = ''
        direnv_layout_dir() {
            local hash path
            hash="$(sha1sum - <<< "$PWD" | head -c40)"
            path="''${PWD//[^a-zA-Z0-9]/-}"
            echo "${config.xdg.cacheHome}/direnv/layouts/''${hash}''${path}"
        }
      '';
    };
  };

  home.file = {
    ".hushlogin".text = "";
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

  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    nixd
    nixfmt
    nix-output-monitor

    tio
    tree
    htop

    gh
    claude-code
    codex
    tree-sitter
    tealdeer

    nerd-fonts.jetbrains-mono
  ];

  programs = {
    ghostty = {
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

    fish = {
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
      functions = {
        mdcd = "mkdir -p $argv; and cd $argv[-1]";
        update = ''
          if type -q darwin-rebuild
            sudo darwin-rebuild switch --flake $HOME/dev/nixfiles
          else
            home-manager switch --flake $HOME/dev/nixfiles
          end
        '';
      };
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

    direnv = {
      enable = true;
      silent = true;
      nix-direnv.enable = true;
    };

    neovim = {
      enable = true;
      defaultEditor = true;
      withPython3 = false;
      withRuby = false;
    };

    git = {
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
        "Icon?"
        "Thumbs.db"
      ];
    };

    lazygit.enable = true;
    ripgrep.enable = true;
    fd.enable = true;
    fzf.enable = true;
    bat.enable = true;

    # Let Home Manager install and manage itself.
    home-manager.enable = true;
  };
}
