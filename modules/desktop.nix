{ config, lib, pkgs, ... }:

{
  # Enable all the nerdfonts.
  fonts.packages = with pkgs; [
    corefonts
    noto-fonts
    noto-fonts-color-emoji
    liberation_ttf
    liberation-sans-narrow
    dejavu_fonts
    nerd-fonts.jetbrains-mono
  ];

  # Hyprland.
  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
  };

  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = "br";
        variant = "thinkpad";
      };
      displayManager.lightdm.enable = true;
    };
  };

  # Enable sound. Use Pulseaudio only (no Pipewire).
  services.pulseaudio.enable = true;
  services.pipewire.enable = false;

  # Enable touchpad support.
  services.libinput.enable = true;

  # Enable upower.
  services.upower.enable = true;

  # Enable dark theme for GTK applications.
  environment.variables = {
    GTK_THEME = "Adwaita-dark"; # Fallback for legacy GTK3
    LIBREOFFICE_LANG = "en.US_UTF-8";
  };
  programs.dconf.enable = true;

  # Bridge the dconf settings to Wayland apps in Hyprland
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
