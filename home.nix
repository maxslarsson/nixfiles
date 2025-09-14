{ config, pkgs, ... }:
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home = {
    username = "maxlarsson";
    homeDirectory = "/Users/maxlarsson";
  };

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

  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nil
    nixfmt-rfc-style
    (python3.withPackages (python-pkgs: with python-pkgs; [
      ipython
    ]))

    # GUI apps
    slack
    zoom-us

    # Mac specific
    raycast
    rectangle
  ];

  programs = {
    ghostty = {
      enable = true;
      package = null;
      enableFishIntegration = true;
      settings = {
        theme = "GruvboxDark";
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
        { name = "gruvbox"; src = gruvbox.src; }
        # Prompt
        { name = "tide"; src = tide.src; }
        # Z dir jumping
        { name = "z"; src = z.src; }
        # FZF
        { name = "fzf"; src = fzf-fish.src; }
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
    };

    git = {
      enable = true;
      userName = "Max Larsson";
      userEmail = "maxslarsson@gmail.com";
    };

    firefox = {
      enable = true;
      package = pkgs.firefox-devedition;
      policies = {
        ExtensionSettings = {
          "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
          };
          # ClearURLs
          "{74145f27-f039-47ce-a470-a662b129930a}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/clearurls/latest.xpi";
            installation_mode = "force_installed";
          };
          # Vimium
          "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium/latest.xpi";
            installation_mode = "force_installed";
          };
          # iCloud Passwords
          "password-manager-firefox-extension@apple.com" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/icloud-passwords/latest.xpi";
            installation_mode = "force_installed";
          };
        };
      };
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
