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

  # Enable nix flakes, not yet stable.
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  networking = {
    useDHCP = false;
    hostName = "fractal";
    interfaces.enp4s0.useDHCP = true;
    firewall.enable = false;
  };

  services = {
    fstrim.enable = true;
    tailscale.enable = true;
  };

  virtualisation.libvirtd.enable = true;
}
