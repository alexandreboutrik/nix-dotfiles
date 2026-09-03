{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Writing
    texstudio
    texliveFull
    typst
    tinymist
    marktext

    # R
    #R 
    #rPackages.httr 
    #rPackages.ggplot2 
    #positron-bin 
    #rstudio 
    #quarto

    # University
    #jetbrains.idea-community
    #wireshark 
    #ciscoPacketTracer8
  ];
}
