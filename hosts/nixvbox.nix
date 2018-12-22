{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./common.nix
    ];

  # FIXME: UUID detection is currently broken
  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
    fsIdentifier = "provided";
  };
  boot.initrd.checkJournalingFS = false;
  boot.growPartition = true;

  networking.hostName = "nixvbox";
  powerManagement.enable = false;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    dpi = 108;
    layout = "us";
    xkbOptions = "eurosign:e";
    windowManager.i3.enable = true;
  };
}
