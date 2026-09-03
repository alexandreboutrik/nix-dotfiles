{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Applications
    alacritty
    firefox
    telegram-desktop
    libreoffice-stable

    # Viewers
    mpv
    imagemagick
    feh
    mupdf
    qpdf
  ];
}
