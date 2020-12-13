{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./common.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
    timeout = 10;
  };

  networking.hostName = "fractal"; # Define your hostname.

  networking.useDHCP = false;
  networking.interfaces.enp4s0.useDHCP = true;

  networking.firewall.enable = false;

  services.fstrim.enable = true;

  virtualisation.libvirtd.enable = true;
}
