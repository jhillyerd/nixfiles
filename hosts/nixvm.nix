{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./common.nix
  ];

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };
  boot.kernelParams = [ "kvm.ignore_msrs=1" ];

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  powerManagement.enable = false;

  networking = {
    hostName = "nixvm";
    useDHCP = false;
    interfaces.ens33.useDHCP = true;
    firewall.enable = false;
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    dpi = 108;
    layout = "us";
    windowManager.i3.enable = true;
  };

  virtualisation.libvirtd.enable = true;
  virtualisation.vmware.guest.enable = true;

  system.stateVersion = "20.09"; # Did you read the comment?
}
