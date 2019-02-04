# Configuration for Asus Zenbook UX301LA
{ config, pkgs, ... }:

{

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./common.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.kernelParams = [ "acpi_osi=" ]; # Enable screen brightness
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [ "md_mod" "raid0" "efivars" ]; # Intel RAID

  i18n.consoleFont = "${pkgs.terminus_font}/share/consolefonts/ter-728n.psf.gz";

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
    dpi = 160;
    libinput = {
      enable = true;
      naturalScrolling = true;
    };
    windowManager.i3.enable = true;
  };
}
