{ config, lib, pkgs, ... }:
with lib;
{
  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?

  # Collect nix store garbage and optimise daily.
  nix.gc.automatic = true;
  nix.optimise.automatic = true;

  time.timeZone = "US/Pacific";

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  # Packages
  nix.useSandbox = false;
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs;
    let
      x-www-browser =
        pkgs.writeShellScriptBin "x-www-browser" ''
          exec ${pkgs.google-chrome}/bin/google-chrome-stable "$@"
        '';
      vim-is-neovim =
        pkgs.writeShellScriptBin "vim" ''
          exec ${pkgs.neovim}/bin/nvim "$@"
        '';

      common = [
        bind
        docker
        file
        git
        gitAndTools.gitflow
        gcc
        gnumake
        jq
        lsof
        lynx
        ncat
        neovim
        patchelf
        python3
        tmux
        tree
        universal-ctags
        unzip
        vim-is-neovim
        weechat
        wget
        zip
      ];

      withxorg = [
        firefox
        google-chrome
        elementary-icon-theme
        rxvt_unicode-with-plugins
        x-www-browser
        xautolock
        xorg.xdpyinfo
        xorg.xev
      ];

      noxorg = [
        rxvt_unicode.terminfo
      ];

    in common ++ (if config.services.xserver.enable then withxorg else noxorg);

  fonts.fonts = with pkgs; [
    font-droid
    inconsolata
    terminus_font
  ];

  # Programs and Services
  programs.fish.enable = true;

  services.sshd.enable = true;

  virtualisation.docker.enable = true;

  # Environment
  environment.sessionVariables = {
    # Workaround for fish: https://github.com/NixOS/nixpkgs/issues/36146
    TERMINFO_DIRS = "/run/current-system/sw/share/terminfo";
  };

  # Users
  users.mutableUsers = true;

  users.users.james = {
    uid = 1001;
    isNormalUser = true;
    home = "/home/james";
    description = "James Hillyerd";
    extraGroups = [ "audio" "docker" "networkmanager" "vboxsf" "wheel" ];
    shell = pkgs.fish;
    initialPassword = "hello github";
  };
}
