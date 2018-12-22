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
    defaultGateway = "192.168.1.1";
    hostName = "cubi";
    nameservers = [ "8.8.8.8" ];
    useDHCP = false;
  };
  networking.interfaces.enp2s0.ipv4.addresses = [
    {
      address = "192.168.1.10";
      prefixLength = 24;
    }
  ];

  services.fstrim.enable = true;
}
