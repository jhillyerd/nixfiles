{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./common.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "ryzen"; # Define your hostname.

  networking.useDHCP = false;
  networking.interfaces.enp4s0.useDHCP = true;

  networking.firewall.enable = false;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    dpi = 108;
    layout = "us";
    windowManager.i3.enable = true;
  };

  virtualisation.libvirtd.enable = true;
}
