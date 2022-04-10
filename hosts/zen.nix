# Configuration for Asus Zenbook UX301LA
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

  networking = {
    hostName = "zen";
    useDHCP = false;
    wireless = {
      enable = true;
      interfaces = [ "wlp2s0" ];
    };
    interfaces.wlp2s0.useDHCP = true;
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    enableCtrlAltBackspace = true;
    layout = "us";
    dpi = 160;
    libinput = {
      enable = true;
      accelSpeed = "0.40";
      naturalScrolling = true;
    };
    windowManager.bspwm.enable = true;
  };

  system.stateVersion = "20.09"; # Did you read the comment?
}
