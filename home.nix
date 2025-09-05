{ config, lib, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "maxlarsson";
  home.homeDirectory = "/Users/maxlarsson";

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
    };
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.lazygit
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/maxlarsson/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "nvim";
  };

  home.activation.configure-tide = lib.hm.dag.entryAfter ["writeBoundary"] ''
    ${pkgs.fish}/bin/fish -c "tide configure --auto --style=Lean --prompt_colors='16 colors' --show_time='12-hour format' --lean_prompt_height='Two lines' --prompt_connection=Disconnected --prompt_spacing=Compact --icons='Few icons' --transient=No"
  '';

  programs = {
    ghostty = {
      enable = true;
      package = null;
      enableFishIntegration = true;
      settings = {
        theme = "GruvboxDark";
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
        set -h fish_color_error red
      '';
      shellAbbrs = {
        c = "clear";
        l = "ls -alh";
        v = "nvim";
        gg = "lazygit";
        update = "home-manager switch --flake ${toString ./.}";
      };
      functions = {
        mdcd = "mkdir -p $argv; and cd $argv[-1]";
      };
      plugins = [
        # Gruvbox theme
        { name = "gruvbox"; src = pkgs.fishPlugins.gruvbox.src; }
        # Prompt
        { name = "tide"; src = pkgs.fishPlugins.tide.src; }
        # Z dir jumping
        { name = "z"; src = pkgs.fishPlugins.z.src; }
        # FZF
        { name = "fzf"; src = pkgs.fishPlugins.fzf-fish.src; }
      ];
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

    # Let Home Manager install and manage itself.
    home-manager.enable = true;
  };
}
