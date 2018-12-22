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
  boot.initrd.checkJournalingFS = false;
  boot.growPartition = true;

  networking.hostName = "cubi";
  powerManagement.enable = true;
}
