{ pkgs, ... }: {
  home.packages = with pkgs; [
    # System Monitors & Fetchers
    fastfetch
    btop
    hyperfine
    sloc
    tokei
    tree

    # Archiving & File Operations
    unzip
    p7zip
    zip
    bc
    killall
    ueberzug
  ];
}
