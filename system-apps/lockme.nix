{ pkgs, lib, ... }:

pkgs.buildNimPackage rec {
  pname = "lockme";
  version = "latest";

  src = pkgs.fetchFromGitHub {
    owner = "greenm01";
    repo = "lockme";
    rev = "4eeeec0aa33187b30aec8d52e243ef66e099c5ac";
    hash = "sha256-coQhMuJvd1ZvUZ1TNDql7whnWwwQ4TzcQlLrP+NqdNU=";
  };

  # Provide the lockfile to resolve nimkdl and other dependencies
  lockFile = ./.lockme.json;

  # Bypass sandbox path errors
  doCheck = false;

  nativeBuildInputs = with pkgs; [
    pkg-config
    wayland-scanner
  ];

  buildInputs = with pkgs; [
    wayland
    libxkbcommon
    pam
    libGL # EGL and GLESv2
  ];
}
