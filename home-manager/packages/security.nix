{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Networking
    dig
    nmap

    # Sandboxing
    firejail

    # Crypto Utils
    gnupg
    pinentry-curses

    # AI
    #ollama
    #gemini-cli

    # Cybersecurity
    #ghidra-bin 
    #gdb
    #pwntools 
    #burpsuite 
    #semgrep
  ];
}
