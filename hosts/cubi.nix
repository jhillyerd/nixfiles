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

  # Enable nix flakes, not yet stable.
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  networking = {
    useDHCP = false;
    hostName = "cubi";
    interfaces.enp2s0.useDHCP = true;
    firewall.enable = false;
  };

  services.fstrim.enable = true;

  virtualisation.libvirtd.enable = true;
}
