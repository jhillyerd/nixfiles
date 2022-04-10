{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./common.nix
    ];

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
    # UUID detection is currently broken
    fsIdentifier = "provided";
  };
  boot.initrd.checkJournalingFS = false;
  boot.growPartition = true;

  fileSystems."/" = {
    autoResize = true;
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  powerManagement.enable = false;

  networking.hostName = "nixvbox";
  networking.firewall.enable = false;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    dpi = 108;
    layout = "us";
    windowManager.i3.enable = true;
  };

  virtualisation.libvirtd.enable = true;

  system.stateVersion = "20.09"; # Did you read the comment?
}
