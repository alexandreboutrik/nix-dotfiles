# Nix Dotfiles

![Version](https://img.shields.io/github/v/tag/alexandreboutrik/nix-dotfiles?label=Version&color=blue)

`nix-dotfiles` is a reproducible, hardened, multi-host NixOS configuration built with Nix Flakes and Home Manager. It provides a lightweight Wayland tiling desktop, specialized developer environments, and kernel-to-application security hardening.

## Deployment

```bash
git clone git@github.com:alexandreboutrik/nix-dotfiles.git ~/nix-dotfiles
cd ~/nix-dotfiles

# Rebuild for Lenovo ThinkPad T480
sudo nixos-rebuild switch --flake .#t480

# Rebuild for Dell Rugged 5424
sudo nixos-rebuild switch --flake .#d5424
```

## Desktop Environment

The graphical desktop is built around Wayland.

| Component | Software |
|:----------|:---------|
| Booloader | `systemd-boot` |
| Libc/toolchain | `glibc`, `llvm/clang` |
| Filesystem | `ext4` |
| Display Manager | headless tty1 autostart, `lockme` |
| Window Manager | `hyprland` with `XWayland` support |
| Status Bar | `waybar` |
| Application Launcher | `wofi` |
| Browser | `firefox` |
| Terminal | `alacritty` with `bash` |
| Editor | native `nvim` |

## Security & System Hardening

**Full Disk Encryption**. Partitions are fully encrypted using LUKS (`/dev/disk/by-label/nix-encrypted`) and unlocked during the `initrd` stage before LVM activation.

**Rust-based Sudo (`sudo-rs`)**. The traditional `sudo` binary is disabled in favor of `security.sudo-rs`.

**Sysctl Hardening**. The kernel runtime is locked down by disabling unprivileged BPF, preventing kexec usage, enforcing aggressive KASLR, and completely hiding kernel pointers from user space. At the network layer, the stack mitigates attacks by enabling TCP SYN cookies, RFC 1337 TIME-WAIT protection, and reverse path filtering, while actively ignoring ICMP broadcast requests, ICMP redirects, and source routing attempts.

**Boot Parameters**. The kernel is initialized with boot parameters designed to defeat memory corruption and hardware vulnerabilities. These parameters disable slab merging, enforce zero-filled memory allocations upon creation and deletion, mandate Kernel Control Flow Integrity, and more. Furthermore, hardware-level mitigations for speculative execution flaws like Spectre, Meltdown, and TAA are also enforced.

**Systemd Directives**. `systemd-rfkill`, `NetworkManager` and `sshd` are constrained/sandboxed to limit their blast radius in the event of an exploit. These constraints utilize strict systemd directives like restricted namespaces, denied write-execute memory mappings, protected home directories, and native syscall architecture filters to prevent compromised daemons from escalating privileges across the wider system.

**NetFilter NFTables**. The default NixOS firewall is replaced by a custom, declarative `nftables` service that enforces a strict drop policy for all unsolicited input, output, and forward traffic. The ruleset manages secure bridge routing for Incus virtualization, filters spoofed subnets on external interfaces, drops ping requests, and actively intercepts and logs TCP flag port scans such as NULL, XMAS, and SYN/RST patterns.

**Screen Locker**. The `lockme` screen locker provides privilege separation by forking a PAM auth child over a length-prefixed pipe. Transient password material is protected in a page-aligned buffer rounded up to a page multiple, secured with `mlock` and `MADV_DONTDUMP`, and cleared using `explicit_bzero`. The locker process is further hardened by dropping dumpability, denying new privileges, and suppressing core dumps.

**Firefox Browser**. Firefox is deployed as a Flatpak and isolated using declarative Flatseal overrides. Then, Firefox is further locked down through declarative Nix policies and a strict `user.js` adapted from [pyllyukko's user.js](https://github.com/pyllyukko/user.js).

## Considerations & Exclusions

**Plausible Deniability**. Because these laptops are highly mobile (used for university and travel), plausible deniability within the LUKS storage setup is currently under consideration to further protect against coerced decryption, though it is not yet implemented.

**Hardened Memory Allocators**. Integrating hardened memory allocators like Scudo or Graphene-hardened into a dedicated, per-package sandboxing layer (such as Flatpak) is currently under consideration.

**`uutils/coreutils`**. While the system aim to replace traditional C utilities with memory-safe Rust alternatives such as `sudo-rs`, replacing GNU coreutils with `uutils` is NOT under consideration. The `uutils` project remains too imature and not production-ready for a daily driver system, presenting a risk of breaking standard shell scripts and established system expectations.

## LICENSE

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT). Feel free to use, modify, and distribute the code as needed. See the [LICENSE](LICENSE) file for more information.
