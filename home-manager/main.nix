{ config, lib, pkgs, ... }:

let
	forceDir = source: {
		inherit source;
		recursive = true;
		force = true;
	};
in
{
	home-manager.useGlobalPkgs = true;
	home-manager.useUserPackages = true;

  home-manager.users.boutrik = { pkgs, ... }: {
    home.stateVersion = "25.05";

		home.packages = with pkgs; [
			# Commands & Utils
			tree grim slurp fastfetch ueberzug bc
			unzip p7zip zip
			sloc tokei
			wf-recorder libnotify mako mpv wtype
			gnupg pinentry-curses
			imagemagick mupdf qpdf feh
			hyperfine dig nmap killall btop

			# System & Interface
			waybar wofi fuzzel wl-clipboard hyprpaper
			brightnessctl alsa-utils

			# Desktop apps
			alacritty firefox telegram-desktop
			libreoffice-fresh
			texstudio texlive.combined.scheme-full
			typst tinymist
			marktext

			# Development
			gh git
			gnumake cmake ninja
			glibc.static llvm clang clang-tools man-pages pkg-config
			android-tools

			# Languages
			jdk jdt-language-server maven scala
			zig zls
			cargo rust-analyzer rustc
			go gopls
			python3 pyright
			ghc cabal-install haskell-language-server hlint
			lua
			sqlx-cli
			shfmt
			nodejs_24 yarn
			typescript typescript-language-server
			vue-language-server svelte-language-server

			# Formal Verification
			why3 alt-ergo z3 cvc5
			framac compcert
			jasmin-compiler easycrypt

			# Mobile
			#android-studio gradle

			# AI & Cybersecurity
			#ollama gemini-cli
			#ghidra-bin gdb
			#pwntools burpsuite semgrep
			firejail

			# University stuff
			#R rPackages.httr rPackages.ggplot2 positron-bin rstudio quarto
			#jetbrains.idea-community
			#wireshark ciscoPacketTracer8
		];

		xdg.configFile = {
			"hypr" = forceDir ./hypr;
			"waybar" = forceDir ./waybar;
			"nvim" = forceDir ./nvim;
		};

    home.file = {
			".bashrc" = forceDir ./bashrc;
		};

		gtk = {
			enable = true;
			theme = {
			  name = "Adwaita-dark";
			  package = pkgs.gnome-themes-extra;
			};
			gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
			gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
			gtk4.theme = null;
		};

		dconf.settings = {
			"org/gnome/desktop/interface" = {
				color-scheme = "prefer-dark";
			};
		};
  };
}
