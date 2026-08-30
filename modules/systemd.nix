{ config, lib, pkgs, ... }:

{
  systemd.services.systemd-rfkill = {
    serviceConfig = {
      ProtectSystem = "strict";
      ProtectHome = true;
      ProtectKernelTunables = true;
      ProtectControlGroups = true;
      ProtectClock = true;
      ProcSubset = "pid";
      PrivateTmp = true;
      NoNewPrivileges = true;
      IPAddressDeny = "any";
      Umask = "0077";
    };
  };

  systemd.services.NetworkManager-dispatcher = {
    serviceConfig = {
      ProtectHome = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectControlGroups = true;
      ProtectKernelLogs = true;
      ProtectHostname = true;
      ProtectClock = true;
      ProtectProc = "invisible";
      ProcSubset = "pid";
      PrivateUsers = true;
      MemoryDenyWriteExecute = true;
      NoNewPrivileges = true;
      RestrictSUIDSGID = true;
      RestructNamespaces = true;
      Umask = "0077";
    };
  };

  systemd.services.NetworkManager = {
    serviceConfig = {
      ProtectHome = true;
      PrivateTmp = true;
      NoNewPrivileges = true;
      ProtectKernelLogs = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectControlGroups = true;
      ProtectClock = true;
      MemoryDenyWriteExecute = true;
      ProtectProc = "invisible";
      ProcSubset = "pid";
      RestrictNamespaces = true;
      Umask = "0077";
    };
  };
}
