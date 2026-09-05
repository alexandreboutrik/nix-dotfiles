{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Applications
    alacritty
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
