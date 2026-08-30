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

      ExecStart = pkgs.writeShellScript "iptables-start" ''
        #!/usr/bin/env bash
        iptables -F
        iptables -X
        iptables -Z

        iptables -P INPUT DROP
        iptables -P OUTPUT DROP
        iptables -P FORWARD DROP

        # Allow loopback
        iptables -A INPUT -i lo -j ACCEPT
        iptables -A OUTPUT -o lo -j ACCEPT

        # Allow established and related connections
        iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

        # Allow SSH
        iptables -A OUTPUT -p tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
        iptables -A OUTPUT -p tcp --dport 22212 -m state --state NEW,ESTABLISHED -j ACCEPT

        # Allow HTTP and HTTPS
        iptables -A OUTPUT -p tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
        iptables -A OUTPUT -p tcp --dport 443 -m state --state NEW,ESTABLISHED -j ACCEPT

        # Allow DNS
        iptables -A OUTPUT -p udp --dport 53 -m state --state NEW,ESTABLISHED -j ACCEPT

				# Allow UniCA WiFi portal
				iptables -A OUTPUT -p tcp --dport 8003 -m state --state NEW,ESTABLISHED -j ACCEPT

				# INCUS : Allow VMs to talk to the host (needed for DHCP and DNS)
        iptables -A INPUT -i incusbr0 -j ACCEPT
        
        # INCUS : Allow host to reply to VMs (and connect to them locally)
        iptables -A OUTPUT -o incusbr0 -j ACCEPT
        
        # INCUS : Allow VMs to reach the internet
        iptables -I FORWARD 1 -i incusbr0 -j ACCEPT
        
        # INCUS : Allow established internet traffic back into the VMs
        iptables -I FORWARD 1 -o incusbr0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

        # Prevents ping
        iptables -A INPUT -p icmp --icmp-type echo-request -j DROP
        iptables -A OUTPUT -p icmp --icmp-type echo-request -j ACCEPT

        # IP spoofing
        iptables -A INPUT -s 172.16.0.0/16 -i wlan0 -j DROP
        iptables -A INPUT -s 192.168.0.0/24 -i wlan0 -j DROP

        # Port scanning
        iptables -N SCANNER
        iptables -A SCANNER -j LOG --log-prefix "IPTables SCANNER "
        iptables -A SCANNER -j DROP
        iptables -A INPUT -p tcp --tcp-flags ALL FIN,URG,PSH -i wlan0 -j SCANNER
        iptables -A INPUT -p tcp --tcp-flags ALL NONE -i wlan0 -j SCANNER
        iptables -A INPUT -p tcp --tcp-flags ALL FIN,SYN -i wlan0 -j SCANNER
        iptables -A INPUT -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -i wlan0 -j SCANNER
        iptables -A INPUT -p tcp --tcp-flags SYN,RST SYN,RST -i wlan0 -j SCANNER
        iptables -A INPUT -p tcp --tcp-flags SYN,FIN SYN,FIN -i wlan0 -j SCANNER
      '';

      ExecStop = pkgs.writeShellScript "iptables-stop" ''
        #!/usr/bin/env bash
        iptables -F
        iptables -X
        iptables -Z

        iptables -P INPUT ACCEPT
        iptables -P OUTPUT ACCEPT
        iptables -P FORWARD ACCEPT
      '';

      RemainAfterExit = true;
    };
  };
}
