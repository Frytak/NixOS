{ config, lib, pkgs, ... }:

{
    options.modules.home.hyfetch = {
        enable = lib.mkEnableOption "hyfetch";

	ascii = lib.mkOption {
	    type = lib.types.enum ["auto" "bad_dragon"];
	    description = "ASCII art to be displayed by neofetch backend.";
	    default = "auto";
	    example = ''
	        "bad_dragon"
	    '';
	};
    };

    config = lib.mkIf config.modules.home.hyfetch.enable {
        programs.hyfetch = {
            enable = true;
            settings = {
                    preset = "gay-men";
                    mode = "rgb";

                    light_dark = "dark";
                    lightness = 0.5;

                    color_align = {
                        mode = "horizontal";
                        custom_colors = [];
                        fore_back = null;
            };

                #args = "--ascii ~/.config/neofetch/ascii.txt";
                    backend = "neofetch";
                    pride_month_disable = false;
            };
        };

        home.file.".config/neofetch/config.conf".source = ./neofetch.conf;
        home.file.".config/neofetch/ascii.txt".source = ./asciiArt/${config.modules.home.hyfetch.ascii}.txt;
    };
}
