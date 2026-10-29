{ pkgs, ... }: {
  home.packages = with pkgs; [
    # System Monitors & Fetchers
    fastfetch
    btop
    hyperfine
    sloc
    tokei
    tree
    jq
    nvd

    # Archiving & File Operations
    unzip
    p7zip
    zip
    bc
    killall
    ueberzug
  ];
}
