{ config, lib, pkgs, ... }:
with lib;
{
  # Collect nix store garbage and optimise daily.
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 14d";
  };
  nix.optimise.automatic = true;

  time.timeZone = "America/Los_Angeles";

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
        bat
        bind
        chezmoi
        docker
        file
        fzf
        git
        gitAndTools.gh
        gitAndTools.git-absorb
        gitAndTools.gitflow
        gcc
        gnumake
        htop
        jq
        lsof
        lynx
        ncat
        neovim
        nixfmt
        nodejs
        patchelf
        psmisc
        python3
        ripgrep
        starship
        tmux
        tree
        universal-ctags
        unzip
        usbutils
        vim-is-neovim
        weechat
        wget
        zip
      ];

      withxorg = [
        dmenu
        firefox
        gnome3.gedit
        google-chrome
        imwheel
        kitty
        pantheon.elementary-icon-theme
        polybarFull
        rxvt_unicode-with-plugins
        virt-manager
        scrot
        sxhkd
        x-www-browser
        xorg.xdpyinfo
        xorg.xev
        xsecurelock
        xss-lock
      ];

      noxorg = [
        rxvt_unicode.terminfo
      ];

    in common ++ (if config.services.xserver.enable then withxorg else noxorg);

  programs.dconf.enable = config.services.xserver.enable;

  fonts.fonts = with pkgs; [
    inconsolata
    noto-fonts
    siji
    terminus_font
    unifont
  ];

  # Programs and Services
  programs.fish.enable = true;

  services.sshd.enable = true;

  services.udev.extraRules = ''
    ACTION!="add|change", GOTO="probe_rs_rules_end"
    SUBSYSTEM=="gpio", MODE="0660", GROUP="dialout", TAG+="uaccess"
    SUBSYSTEM!="usb|tty|hidraw", GOTO="probe_rs_rules_end"
    # STMicroelectronics ST-LINK/V2
    ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3748", MODE="660", GROUP="dialout", TAG+="uaccess"
    LABEL="probe_rs_rules_end"
  '';

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
    extraGroups = [ "audio" "dialout" "docker" "libvirtd" "networkmanager" "vboxsf" "wheel" ];
    shell = pkgs.fish;
    initialPassword = "hello github";
  };
}
