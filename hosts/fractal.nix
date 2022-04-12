{ config, pkgs, ... }: {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./common.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
    timeout = 10;
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # Enable nix flakes, not yet stable.
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    trustedUsers = [ "root" "james" ];
  };

  networking = {
    useDHCP = false;
    hostName = "fractal";
    interfaces.enp4s0.useDHCP = true;
    firewall.enable = false;
  };

  services = {
    fstrim.enable = true;
    tailscale.enable = true;

    # Enable the X11 windowing system.
    xserver = {
      enable = true;
      layout = "us";
      windowManager.i3.enable = true;
    };
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  virtualisation.libvirtd.enable = true;

  system.stateVersion = "21.11"; # Did you read the comment?
}
