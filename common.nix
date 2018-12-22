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
        ncat
        patchelf
        python3
        tmux
        tree
        universal-ctags
        unzip
        vimHugeX
        weechat
        wget
        zip
      ];

      xorg = [
        firefox
        google-chrome
        rxvt_unicode-with-plugins
        x-www-browser
      ];

      noxorg = [];
      
    in common ++ (if config.services.xserver.enable then xorg else noxorg);

  fonts.fonts = with pkgs; [
    font-droid
    inconsolata
  ];

  programs.fish.enable = true;

  virtualisation.docker.enable = true;

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
