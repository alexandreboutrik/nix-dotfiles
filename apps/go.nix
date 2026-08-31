{ config, pkgs, ... }:

{
  programs = {
    go = {
      enable = true;
      env = {
        GOBIN = "${config.home.homeDirectory}/.go/bin";
        GOPATH = "${config.home.homeDirectory}/.go";
      };
    };
  };
}
