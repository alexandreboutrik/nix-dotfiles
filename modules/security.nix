{ config, lib, pkgs, ... }:

{
  # Harden kernel.
  boot.kernel.sysctl = {
    # Network
    "net.core.bpf_jit_harden" = 2;
    "net.ipv4.tcp_timestamps" = 0; # Disables TCP timestamps.
    "net.ipv4.tcp_congestion_control" = "bbr"; # Google's BBR.
    "net.ipv4.tcp_syncookies" = 1; # Mitigates SYN flood attacks.
    "net.ipv4.tcp_synack_retries" = 5;
    "net.ipv4.tcp_rfc1337" = 1; # RFC1337 TIME-WAIT protection.
    "net.ipv4.tcp_sack" = 0;
    "net.ipv4.tcp_dsack" = 0;
    "net.ipv4.tcp_fack" = 0;
    "net.ipv4.conf.default.send_redirects" = 0; # ICMP redirects.
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
    "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
    "net.ipv4.conf.default.accept_source_route" = 0; # Source routing.
    "net.ipv4.conf.all.accept_source_route" = 0;
    "net.ipv4.conf.default.rp_filter" = 1; # Reverse path filtering.
    "net.ipv4.conf.all.rp_filter" = 1;
    "net.ipv4.conf.default.log_martians" = 1; # Impossible addresses.
    "net.ipv4.conf.all.log_martians" = 1;
    "net.ipv4.conf.default.shared_media" = 0; # ARP shared media.
    "net.ipv4.conf.all.shared_media" = 0;
    "net.ipv4.conf.default.arp_ignore" = 1;
    "net.ipv4.conf.all.arp_ignore" = 1;
    "net.ipv4.conf.default.drop_gratuitous_arp" = 1;
    "net.ipv4.conf.all.drop_gratuitous_arp" = 1;

    # Kernel
    "kernel.kptr_restrict" = 2; # Hide kernel pointers.
    "kernel.randomize_va_space" = 2; # KASLR.
    "kernel.sysrq" = 0; # Disables sysqr key.
    "kernel.unprivileged_bpf_disabled" = 1;
    #"kernel.unprivileged_userns_clone" = 1;
    #"kernel.yama.ptrace_scope" = 3; # Disables ptrace. 
    #"kernel.perf_event_paranoid" = 3;

    # File System
    "fs.suid.dumpable" = 0;
    "fs.protected_hardlinks" = 1;
    "fs.protected_symlinks" = 1;
    "fs.protected_fifos" = 2;
    "fs.protected_regular" = 2;

    # Virtualization
    "vm.unprivileged_userfaultfd" = 0;
  };

  boot.kernelParams = [
    # Prevents merging similar memory slabs.
    # Hardens against heap attacks.
    "slab_nomerge"
    # Frees memory with a poison value (0xAA).
    # Catches Use-after-Free (UaF) early.
    # CONFIG_PAGE_POISONING takes precedence over init_on_alloc and init_on_free.
    "page_poison=1"
    # Zero-fills memory when allocated.
    # Defeats Use-after-Free (UaF) leaks.
    #"init_on_alloc=1"
    # Zero-fills memory when freed.
    # Reduces sensitive data remnants.
    #"init_on_free=1"
    # Randomizes page allocation.
    # Mitigates memory layout guessing.
    "page_alloc.shuffle=1"

    # Enables Page Table Isolation (PTI).
    # Mitigates Meltdown.
    "pti=on"
    # Enable Spectre v2 mitigations.
    # Blocks speculative execution attacks.
    "spectre_v2=on"
    # Disables speculative store bypass (Spectre v4).
    # Mitigates another Spectre variant.
    "spec_store_bypass_disable=on"
    # Prevents huge-page side-channel attacks in VMs.
    # Hardens KVM Hypervisor.
    "kvm.nx_huge_pages=force"

    # Disables obsolete vsyscall.
    "vsyscall=none"
    # Disables Hyper-Threading. Kills Spectre/MDS/TAA.
    #nosmt=force
    # Disables Intel TSX (fixes TAA).
    #tsx=off
  ];

  # Cloudlfare DNS.
  networking.nameservers = [ "1.1.1.1" "1.1.0.0" ];

  # Randomize MAC Address.
  networking.networkmanager.wifi.macAddress = "random";

  # Use sudo-rs instead of sudo.
  security.sudo.enable = false;
  security.sudo-rs = {
    enable = true;
    execWheelOnly = true; # Only wheel group members can use sudo.
    wheelNeedsPassword = true;
  };

  # Disable SMT.
  #security.allowSimultaneousMultithreading = false;

  # Enable PTI.
  #security.forcePageTableIsolation = true;

  # Paranoid options.
  #security.allowUserNamespaces = false;
  #security.virtualisation.flushL1DataCache = "always";
  #networking.tcpcrypt.enable = true;
}
