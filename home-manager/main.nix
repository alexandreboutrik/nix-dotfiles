{ config, lib, pkgs, ... }:

let
  forceDir = source: {
    inherit source;
    recursive = true;
    force = true;
  };
in
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.boutrik = { pkgs, ... }: {
    imports = [
      ./packages/wayland.nix
      ./packages/cli.nix
      ./packages/desktop.nix
      ./packages/development.nix
      ./packages/academic.nix
      ./packages/security.nix
      ./packages/verification.nix
    ];

    home.stateVersion = "25.05";

    xdg.configFile = {
      "hypr" = forceDir ./hypr;
      "waybar" = forceDir ./waybar;
      "nvim" = forceDir ./nvim;
    };

    programs.bash = {
      enable = true;
      initExtra = builtins.readFile ./bashrc;
    };

    gtk = {
      enable = true;
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };
      gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
      gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
      gtk4.theme = null;
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };
}
