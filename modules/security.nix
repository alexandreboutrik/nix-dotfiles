{ config, lib, pkgs, ... }:

{
  # Harden kernel.
  boot.kernel.sysctl = {
    # ==================== #
    #        Network       #
    # ==================== #

    # SYSCTL: Enable eBPF JIT hardening
    # Prevents eBPF JIT spraying attacks by randomizing addresses
    # and blinding constants.
    "net.core.bpf_jit_harden" = 2;

    # SYSCTL: Disable TCP timestamps
    # Prevents uptime calculation and networking profiling via
    # timestamp analysis.
    "net.ipv4.tcp_timestamps" = 0;

    # SYSCTL: Enable BBR congestion control
    # Uses Google's BBR algorithm for better throughput and lower latency.
    "net.ipv4.tcp_congestion_control" = "bbr";

    # SYSCTL: Enable TCP SYN cookies
    # Mitigates SYN flood Denial of Service (DoS) attacks by
    # validating connections.
    "net.ipv4.tcp_syncookies" = 1;

    # SYSCTL: Reduce SYN-ACK retries
    # Drops half-open connections faster to free up resources during a
    # SYN flood.
    "net.ipv4.tcp_synack_retries" = 5;

    # SYSCTL: Enable RFC 1337 TIME-WAIT protection
    # Protects against TIME-WAIT assassination hazards by ignoring
    # RST packets.
    "net.ipv4.tcp_rfc1337" = 1;

    # SYSCTL: Disable Selective ACK (SACK) and related extensions
    # Reduces the TCP stack attack surface (e.g., SACK
    # Panic vulnerabilities).
    # NOTICE: May reduce network performance on connections with high
    # packet loss.
    "net.ipv4.tcp_sack" = 0;
    "net.ipv4.tcp_dsack" = 0;
    "net.ipv4.tcp_fack" = 0;

    # SYSCTL: Disable sending ICMP redirects
    # Prevents the machine from acting as a router and spoofing
    # routing tables.
    "net.ipv4.conf.default.send_redirects" = 0;
    "net.ipv4.conf.all.send_redirects" = 0;

    # SYSCTL: Disable accepting ICMP redirects
    # Prevents malicious network hosts from altering the local
    # routing table.
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.all.accept_redirects" = 0;

    # SYSCTL: Ignore ICMP echo requests sent to broadcast/multicast
    # addresses
    # Mitigates Smurf network amplification attacks.
    "net.ipv4.icmp_echo_ignore_broadcasts" = 1;

    # SYSCTL: Ignore bogus ICMP error responses
    "net.ipv4.icmp_ignore_bogus_error_responses" = 1;

    # SYSCTL: Disable IPv4 source routing
    # Prevents IP spoofing attacks.
    "net.ipv4.conf.default.accept_source_route" = 0;
    "net.ipv4.conf.all.accept_source_route" = 0;

    # SYSCTL: Enable Reverse Path (RP) filtering
    # Drops spoofed packets by verifying the return path matches the
    # incoming interface.
    "net.ipv4.conf.default.rp_filter" = 1;
    "net.ipv4.conf.all.rp_filter" = 1;

    # SYSCTL: Log impossible (martian) addresses
    # Logs packets with source/destination addresses that are
    # logically impossible.
    "net.ipv4.conf.default.log_martians" = 1;
    "net.ipv4.conf.all.log_martians" = 1;

    # SYSCTL: Disable ARP shared media
    # Prevents ARP spoofing on subnets where different IP networks
    # share the same wire.
    "net.ipv4.conf.default.shared_media" = 0;
    "net.ipv4.conf.all.shared_media" = 0;

    # SYSCTL: Enable strict ARP replies
    # Reply only if the target IP address is a local address configured
    # on the incoming interface.
    "net.ipv4.conf.default.arp_ignore" = 1;
    "net.ipv4.conf.all.arp_ignore" = 1;

    # SYSCTL: Drop gratuitous ARP frames
    # Prevents ARP poisoning by dropping unsolicited ARP packets.
    "net.ipv4.conf.default.drop_gratuitous_arp" = 1;
    "net.ipv4.conf.all.drop_gratuitous_arp" = 1;

    # SYSCTL: Disable TCP Fast Open (TFO)
    # Mitigates potential spoofing and amplification attacks abusing TFO.
    #"net.ipv4.tcp_fastopen" = 0;

    # ==================== #
    #        Kernel        #
    # ==================== #

    # SYSCTL: Hide kernel pointers
    # Restricts access to kallsyms.
    "kernel.kptr_restrict" = 2;

    # SYSCTL: Enable Kernel Address Space Layout Randomization (KASLR)
    # Randomizes the memory layout of the kernel.
    "kernel.randomize_va_space" = 2;

    # SYSCTL: Disable the Magic SysRq key
    # Prevents physical console escapes and forced actions.
    # NOTICE: Breaks emergency reboot (REISUB) shortcuts.
    "kernel.sysrq" = 0;

    # SYSCTL: Restrict unprivileged eBPF
    # Limits eBPF calls to users with CAP_SYS_ADMIN capabilities.
    "kernel.unprivileged_bpf_disabled" = 1;

    # SYSCTL: Disable kexec
    # Prevents replacing the running kernel to stop kernel-level
    # persistence attacks.
    # NOTICE: Breaks live kernel patching and kexec-based fast reboots.
    "kernel.kexec_load_disabled" = 1;

    # SYSCTL: Disable TIOCSTI ioctl injection attacks
    # Prevents malicious background processes from injecting input into
    # a TTY terminal.
    "dev.tty.ldisc_autoload" = 0;

    # SYSCTL: Disable unprivileged user namespaces
    # Reduces the kernel attack surface.
    # NOTICE: Breaks unprivileged containers (Docker/Podman), flatpaks,
    # and AppImages.
    #"kernel.unprivileged_userns_clone" = 1;

    # SYSCTL: Restrict ptrace
    # Prevents processes from snooping on other processes (requires
    # CAP_SYS_PTRACE).
    # NOTICE: Breaks debugging tools (gdb, strace) and some Wine/Proton
    # games.
    #"kernel.yama.ptrace_scope" = 3;

    # SYSCTL: Restrict performance monitoring subsystem
    # Prevents unprivileged profiling and side-channel attacks via perf.
    "kernel.perf_event_paranoid" = 3;

    # ==================== #
    #      File System     #
    # ==================== #

    # SYSCTL: Disable core dumps for setuid processes
    # Prevents leaking credentials or sensitive memory to disk.
    "fs.suid.dumpable" = 0;

    # SYSCTL: Prevent hardlink and symlink spoofing
    # Mitigates Time-of-Check to Time-of-Use (TOCTOU) exploits in
    # world-writable directories (e.g., /tmp).
    "fs.protected_hardlinks" = 1;
    "fs.protected_symlinks" = 1;

    # SYSCTL: Protect FIFOs and regular files
    # Prevents unintentional or malicious writes in world-writable
    # directories.
    "fs.protected_fifos" = 2;
    "fs.protected_regular" = 2;

    # ==================== #
    #    Virtualization    #
    # ==================== #

    # SYSCTL: Disable unprivileged userfaultfd
    # Mitigates heap-spraying and use-after-free kernel exploits.
    "vm.unprivileged_userfaultfd" = 0;
  };

  boot.kernelParams = [
    # ==================== #
    #   Kernel Parameters  #
    # ==================== #

    # PARAM: Prevents merging similar memory slabs
    # Hardens against heap attacks by isolating allocations.
    "slab_nomerge"

    # PARAM: Frees memory with a poison value (0xAA)
    # Catches Use-after-Free (UaF) vulnerabilities early.
    # NOTICE: CONFIG_PAGE_POISONING takes precedence over init_on_alloc
    # and init_on_free.
    #"page_poison=1"

    # PARAM: Zero-fills memory when allocated
    # Defeats Use-after-Free (UaF) information leaks.
    "init_on_alloc=1"

    # Zero-fills memory when freed
    # Reduces sensitive data remnants in memory.
    "init_on_free=1"

    # PARAM: Randomizes page allocation
    # Mitigates memory layout guessing.
    "page_alloc.shuffle=1"

    # PARAM: Randomizes the kernel stack offset on every syscall.
    "randomize_kstack_offset=on"

    # PARAM: Force exposed pointers to be hashed (Since v6.17)
    # Obfuscates pointers to deter memory corruption exploits.
    "hash_pointers=always"

    # PARAM: Enables Page Table Isolation (PTI)
    # Mitigates the Meltdown vulnerability.
    "pti=on"

    # PARAM: Enable Spectre v2 and v4 mitigations
    # Blocks speculative execution attacks.
    "spectre_v2=on"
    "spec_store_bypass_disable=on"

    # PARAM: Prevents huge-page side-channel attacks in VMs
    # Hardens the KVM Hypervisor environment.
    "kvm.nx_huge_pages=force"

    # PARAM: Disables obsolete vsyscall
    # Removes vsyscall entirely to avoid it being a fixed-position
    # ROP target.
    "vsyscall=none"

    # PARAM: Disable COMPAT_VDSO
    # Disables legacy 32-bit VDSO mapping to reduce attack surface.
    "vdso32=0"

    # Disables Hyper-Threading (SMT)
    # Kills Spectre, MDS, and TAA hardware vulnerabilities.
    # NOTICE: Will significantly reduce CPU multi-threading performance.
    #"nosmt=force"

    # Disable FineIBT
    # Uses pure KCFI as it provides stronger control-flow integrity.
    "cfi=kcfi"

    # PARAM: Disables Intel TSX
    # Fixes the TSX Asynchronous Abort (TAA) vulnerability.
    "tsx=off"

    # PARAM: Panic on kernel oops
    # Halts the system upon encountering a non-fatal error to prevent
    # exploitable inconsistent states.
    #"oops=panic"

    # PARAM: Disable debugfs
    # Removes a frequent source of kernel information leaks.
    #"debugfs=off"
  ];

  # Cloudlfare DNS.
  networking.nameservers = [ "1.1.1.1" "1.1.0.0" ];

  # Randomize MAC Address.
  networking.networkmanager.wifi.macAddress = "random";

  # Lockme.
  security.pam.services.lockme = { };
  environment.systemPackages = [
    (pkgs.callPackage ../apps/lockme.nix { })
  ];

  # Use sudo-rs instead of sudo.
  security.sudo.enable = false;
  security.sudo-rs = {
    enable = true;
    execWheelOnly = true; # Only wheel group members can use sudo.
    wheelNeedsPassword = true;
  };

  # Use hardened memory allocator (Scudo)
  # NOTICE: Breaks nvim (LuaJIT), Firefox and other applications.
  #environment.memoryAllocator.provider = "scudo";

  # Mount /tmp in RAM
  boot.tmp.useTmpfs = true;

  # Disable SMT. Enable PTI. (NixOS configuration level)
  #security.allowSimultaneousMultithreading = false;
  #security.forcePageTableIsolation = true;

  # Paranoid options.
  #security.allowUserNamespaces = false;
  #security.virtualisation.flushL1DataCache = "always";
  #networking.tcpcrypt.enable = true;
}
