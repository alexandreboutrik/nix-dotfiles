{ config, lib, pkgs, ... }:

{
  users.mutableUsers = true; # allow changing password.
  users.users = {
    vlr = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "audio" "input" ];
    };

    boutrik = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "audio" "input" "ollama" "adbusers" "incus-admin" ];
    };
  };
}
