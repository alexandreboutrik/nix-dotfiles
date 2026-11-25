{ config, lib, pkgs, ... }:

let
  startScript = pkgs.writeShellScript "nftables-start" (builtins.readFile ./nftables-start.sh);
  stopScript = pkgs.writeShellScript "nftables-stop" (builtins.readFile ./nftables-stop.sh);
in
{
  # Disable default firewall to use custom rules.
  networking.firewall.enable = false;

  environment.systemPackages = with pkgs; [
    nftables
  ];

  systemd.services.nftables-custom = {
    description = "Custom nftables firewall rules";
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-pre.target" ];
    before = [ "network-pre.target" "docker.service" ];
    reloadIfChanged = true;

    path = [ "/run/current-system/sw" pkgs.nftables ];

    serviceConfig = {
      Type = "oneshot";

      ExecStart = startScript;
      ExecReload = startScript;
      ExecStop = stopScript;

      RemainAfterExit = true;
    };
  };
}
