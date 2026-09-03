{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Wayland & Hyprland Environment
    waybar
    wofi
    fuzzel
    hyprpaper
    mako
    libnotify

    # Utilities
    wl-clipboard
    wtype
    grim
    slurp
    wf-recorder
    swayimg

    # Hardware Control
    brightnessctl
    alsa-utils
  ];
}
