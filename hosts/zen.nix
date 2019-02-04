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
  boot.initrd.kernelModules = [ "md_mod" "raid0" "efivars" ];

  networking.hostName = "zen";
  networking.wireless.enable = true;
  networking.supplicant.WLAN = {
    configFile.path = "/etc/wpa_supplicant.conf";
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
    dpi = 144;
    libinput.enable = true;
    windowManager.i3.enable = true;
  };
}
