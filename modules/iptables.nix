{ config, lib, pkgs, ... }:

{
  # Disable default firewall to use custom IPTables rules.
  networking.firewall.enable = false;

  systemd.services.iptables = {
    description = "Custom iptables firewall rules";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    before = [ "docker.service" ];
    path = [ "/run/current-system/sw" ];
    serviceConfig = {
      Type = "oneshot";

      ExecStart = pkgs.writeShellScript "iptables-start" (builtins.readFile ./iptables-start.sh);
      ExecStop = pkgs.writeShellScript "iptables-stop" (builtins.readFile ./iptables-stop.sh);

      RemainAfterExit = true;
    };
  };
}
