{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    wireproxy
    (pkgs.writeShellScriptBin "firefox-vpn" ''
      exec firefox -P vpn --no-remote "$@"
    '')
  ];

  systemd.user.services.proton-wireproxy = {
    Unit = {
      Description = "Wireproxy SOCKS5 for VPN";
      After = [ "network-online.target" ];
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      ExecStart = "${pkgs.wireproxy}/bin/wireproxy -c %h/.config/wireguard/vpn.conf";
      Restart = "on-failure";
      NoNewPrivileges = true;
    };
  };

  programs.firefox = {
    enable = true;
    configPath = "${config.xdg.configHome}/mozilla/firefox";

    profiles = {
      default = {
        id = 0;
        isDefault = true;
        name = "default";
        settings = {
          "browser.theme.toolbar-theme" = 2;
          "browser.theme.content-theme" = 2;
          "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
        };
      };

      vpn = {
        id = 1;
        name = "vpn";
        settings = {
          # Route traffic through the local Wireproxy SOCKS5 tunnel
          "network.proxy.type" = 1;
          "network.proxy.socks" = "127.0.0.1";
          "network.proxy.socks_port" = 1080;
          "network.proxy.socks_remote_dns" = true;
          "extensions.activeThemeID" = "{9b728a2e-07c0-4b7b-9ccb-a8d5a52d0263}";
        };
        extensions.packages = [
          (pkgs.stdenv.mkDerivation {
            pname = "matte-dark-red-theme";
            version = "latest";

            src = pkgs.fetchurl {
              url = "https://addons.mozilla.org/firefox/downloads/latest/matte-dark-red-theme/latest.xpi";
              sha256 = "sha256-mZLExAtHLq8iHnL43DSkggYf/JbCRo1ph/do/o+9KKs=";
            };

            buildCommand = ''
              dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
              mkdir -p "$dst"
              install -v -m644 "$src" "$dst/{9b728a2e-07c0-4b7b-9ccb-a8d5a52d0263}.xpi"
            '';
          })
        ]; # extensions
      }; # vpn
    }; # profiles
  }; # programs.firefox
}
