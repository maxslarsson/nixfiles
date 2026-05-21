{ config, pkgs, ... }:
{
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  xdg = {
    enable = true;
    configFile = {
      "nvim" = {
        source = ./nvim;
        recursive = true;
      };

      # Configure the `tide` Fish prompt
      "fish/conf.d/tide-overrides.fish".text = ''
        # Time: show + 12-hour format
        set -g tide_show_time yes
        set -g tide_time_format '%I:%M'

        # Lean prompt height: two lines
        set -g tide_lean_prompt_height 2

        # Prompt connection & spacing
        set -g tide_prompt_connection disconnected
        set -g tide_prompt_spacing compact

        # Icons: few
        set -g tide_prompt_icon_strategy few

        # Transient prompt: off
        set -g tide_left_prompt_transient no
      '';

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

  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    nixd
    nixfmt

    nerd-fonts.jetbrains-mono

    gh
    tealdeer
    nodejs
    (python3.withPackages (
      python-pkgs: with python-pkgs; [
        ipython
      ]
    ))
  ];

  programs = {
    ghostty = {
      enable = true;
      package = null;
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
        rerere = {
          enabled = true;
          autoupdate = true; # Optional: automatically stage resolved conflicts
        };
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
