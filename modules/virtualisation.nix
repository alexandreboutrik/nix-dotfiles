{ config, lib, pkgs, ... }:

{
	# Ollama
	#services.ollama = {
		#enable = true;
		#acceleration = false;
	#};

  # Open WebUI
  #virtualisation.oci-containers.containers.open-webui = {
    #image = "ghcr.io/open-webui/open-webui:main";
    #ports = [ "8888:8080" ];
    #environment = {
      #OPENAI_API_BASE_URL = "https://api.deepseek.com/v1";
      #OPENAI_API_KEY = "[censured]";
    #};
    #volumes = [ "open-webui:/app/backend/data" ];
  #};

  # Virtualbox
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
  users.extraGroups.vboxusers.members = [ "boutrik" ];

  # Docker
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  # Incus
  virtualisation.incus.enable = true;
  networking.firewall.trustedInterfaces = [ "incusbr0" ];
}
