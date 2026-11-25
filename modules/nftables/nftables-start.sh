#!/usr/bin/env bash

nft -f - <<'EOF'
table inet filter {}
flush table inet filter

table inet filter {
    # Dedicated chain for logging and dropping port scans
    chain scanner {
        limit rate 5/minute burst 10 packets log prefix "NFTables SCANNER: " level warn
        drop
    }

    chain input {
        type filter hook input priority 0; policy drop;

        # Allow Loopback
        iif "lo" accept

        # Essential ICMPv6 for Neighbor Discovery & PMTUD (required for IPv6)
        icmpv6 type { nd-neighbor-solicit, nd-neighbor-advert, nd-router-advert, packet-too-big, time-exceeded, destination-unreachable } accept

        # Port scanning protection (TCP flag mapping)
        iifname "wlan0" tcp flags == fin | psh | urg goto scanner
        iifname "wlan0" tcp flags == 0 goto scanner
        iifname "wlan0" tcp flags == fin | syn goto scanner
        iifname "wlan0" tcp flags == syn | rst | ack | fin | urg goto scanner
        iifname "wlan0" tcp flags & (syn | rst) == syn | rst goto scanner
        iifname "wlan0" tcp flags & (syn | fin) == syn | fin goto scanner
 
        # Connection Tracking
        ct state invalid drop
        ct state { established, related } accept

        # INCUS VMs -> Host
        iifname "incusbr0" accept
    }

    chain forward {
        type filter hook forward priority 0; policy drop;

        # INCUS VMs routing to the internet
        iifname "incusbr0" accept
        oifname "incusbr0" ct state { established, related } accept
    }

    chain output {
        type filter hook output priority 0; policy drop;

        # Allow Loopback
        oif "lo" accept

        # Connection Tracking (Global established/related)
        ct state invalid drop
        ct state { established, related } accept

        # Allowed Outbound Services
        tcp dport { 22, 53, 80, 443, 853, 8003, 22212 } ct state new accept
        udp dport { 53, 67, 123, 547 } ct state new accept

        # Allow VPN WireGuard tunnel
        udp dport 51820 ct state new accept

        # Host -> INCUS VMs
        oifname "incusbr0" accept

        # Allow outbound ping
        icmp type echo-request accept
        icmpv6 type { echo-request, nd-neighbor-solicit, nd-neighbor-advert, nd-router-solicit, packet-too-big, time-exceeded, destination-unreachable } accept
    }
}
EOF
