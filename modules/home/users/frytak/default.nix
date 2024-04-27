{ config, ... }:

let
    HOME = /home/frytak;
in

{
    imports = [ ../../default.nix ];
    modules = {
        x11.enable = true;
        nvim.enable = true;
        #firefox.enable = true;
        terminals.alacritty.enable = true;
        shells.fish.enable = true;
	wayland.sway = {
	    enable = true;
	    additionalConfig = ''
	        output eDP-1 mode 1920x1080@60Hz bg ${HOME}/Downloads/foggy_mountains.jpg stretch
	    '';
	};
	home.git.enable = true;
	home.hyfetch = {
	    enable = true;
	    ascii = "bad_dragon";
	};
    };

    home = {
        stateVersion = "23.11";
        username = "frytak";
        homeDirectory = "/home/frytak";
    };
}
