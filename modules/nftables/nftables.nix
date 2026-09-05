{ config, lib, pkgs, ... }:

{
  # Disable default firewall to use custom rules.
  networking.firewall.enable = false;

  environment.systemPackages = with pkgs; [
    nftables
  ];

  systemd.services.nftables-custom = {
    description = "Custom nftables firewall rules";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    before = [ "docker.service" ];

    path = [ "/run/current-system/sw" pkgs.nftables ];

    serviceConfig = {
      Type = "oneshot";

      ExecStart = pkgs.writeShellScript "nftables-start" (builtins.readFile ./nftables-start.sh);
      ExecStop = pkgs.writeShellScript "nftables-stop" (builtins.readFile ./nftables-stop.sh);

      RemainAfterExit = true;
    };
  };
}
