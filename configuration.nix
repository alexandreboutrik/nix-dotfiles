# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./modules/security.nix # security module.
      ./modules/nftables.nix # netfilter.
      ./modules/systemd.nix # systemd services hardening.
      ./modules/virtualisation.nix # vms, containers and sandboxes.
      ./modules/desktop.nix # wm, audio, fonts, input, themes.
      ./modules/users.nix # accounts and groups.
      ./home-manager/main.nix # home dotfiles and packages.
    ];

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.initrd = {
    luks.devices = {
      luksCrypted = {
        device = "/dev/disk/by-label/nix-encrypted";
        preLVM = true; # unlock before activating LVM.
        allowDiscards = true;
      };
    };
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Kernel version
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Disable systemd and bios naming schemes.
  boot.kernelParams = [
    "net.ifnames=0"
    "biosdevname=0"
    "acpi_osi=Linux"
    "i915.enable_dpst=0"
    "i915.enable_fbc=0"
    "i915.enable_psr=0"
  ];

  # Basic networking configuration.
  networking.networkmanager.enable = true;

  # Disable bluetooth.
  #boot.kernelModules = [ "btusb" ];
  hardware.bluetooth = {
    enable = false;
    #  powerOnBoot = false;
    #  settings = {
    #    General = {
    #      Enable = "Source,Sink,Media,Socket"; # A2DP
    #      ControllerMode = "bredr";
    #    };
    #  };
  };
  #services.blueman.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocales = [ "pt_BR.UTF-8/UTF-8" "fr_FR.UTF-8/UTF-8" ];
  };

  # BIOS/UEFI firmware
  services.fwupd.enable = true;

  # Mobile
  nixpkgs.config.android_sdk.accept_license = true;

  # GnuPG
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # System-wide packages.
  environment.systemPackages = with pkgs; [
    neovim
    (pkgs.callPackage ./system-apps/vim.nix { })
    tree-sitter
    nixpkgs-fmt
    git
    wget
    iptables
    pulseaudio
    adwaita-icon-theme
    gtk3
  ];

  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    NIXPKGS_ALLOW_UNFREE = "1";
  };

  programs.nix-ld.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on
  # this particular machine, and is used to maintain compatibility with
  # application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install,
  # for any reason, even if you've upgraded your system to a new NixOS
  # release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS
  # are pulled from, so changing it will NOT upgrade your system - see
  # https://nixos.org/manual/nixos/stable/#sec-upgrading for how to
  # actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean
  # your system is out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the
  # changes it would make to your configuration, and migrated your data
  # accordingly.
  #
  # For more information, see `man configuration.nix` or
  # https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion.
  system.stateVersion = "25.05"; # Did you read the comment?
}
