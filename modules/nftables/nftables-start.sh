#!/usr/bin/env bash

nft -f - <<'EOF'
flush ruleset

table inet filter {
    # Dedicated chain for logging and dropping port scans
    chain scanner {
        log prefix "NFTables SCANNER: " level warn
        drop
    }

    chain input {
        type filter hook input priority 0; policy drop;

        # Allow Loopback
        iif "lo" accept

        # Connection Tracking
        ct state invalid drop
        ct state { established, related } accept

        # INCUS VMs -> Host
        iif "incusbr0" accept

        # Anti-spoofing on wlan0
        iif "wlan0" ip saddr { 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 } drop

        # Port scanning protection (TCP flag mapping)
        iif "wlan0" tcp flags == fin | psh | urg goto scanner
        iif "wlan0" tcp flags == 0 goto scanner
        iif "wlan0" tcp flags == fin | syn goto scanner
        iif "wlan0" tcp flags == syn | rst | ack | fin | urg goto scanner
        iif "wlan0" tcp flags & (syn | rst) == syn | rst goto scanner
        iif "wlan0" tcp flags & (syn | fin) == syn | fin goto scanner
    }

    chain forward {
        type filter hook forward priority 0; policy drop;

        # INCUS VMs routing to the internet
        iif "incusbr0" accept
        oif "incusbr0" ct state { established, related } accept
    }

    chain output {
        type filter hook output priority 0; policy drop;

        # Allow Loopback
        oif "lo" accept

        # Connection Tracking (Global established/related)
        ct state { established, related } accept

        # Allowed Outbound Services
        tcp dport { 22, 80, 443, 8003, 22212 } ct state new accept
        udp dport 53 ct state new accept
        tcp dport 53 ct state new accept

        # Host -> INCUS VMs
        oif "incusbr0" accept

        # Allow outbound ping
        icmp type echo-request accept
    }
}
EOF
