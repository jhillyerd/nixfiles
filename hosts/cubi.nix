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
  };

  networking = {
    useDHCP = false;
    hostName = "cubi";
  };
  networking.interfaces.enp2s0.useDHCP = true;
  networking.firewall.enable = false;

  services.fstrim.enable = true;
}
