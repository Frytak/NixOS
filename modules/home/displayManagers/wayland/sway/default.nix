{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.wayland.sway;
    modifier = config.xsession.windowManager.i3.config.modifier;
in

{
    options.modules.wayland.sway = {
        enable = lib.mkEnableOption "sway";

	additionalConfig = lib.mkOption {
	    type = lib.types.lines;
	    description = "Additional Sway configuration.";
	    default = "";
	    example = ''
	        output HDMI-A-1 mode 1920x1080@60Hz
	    '';
	};
    };
    
    config = lib.mkIf moduleConfig.enable {
        wayland.windowManager.sway = {
	    enable = true;
	    systemd.enable = true;
	    config = rec {
	        modifier = "Mod4";
		terminal = "alacritty";
		window.border = 1;

		keybindings = {
                    "${modifier}+Return" = "exec alacritty";
                    "${modifier}+Shift+q" = "kill";
                    "${modifier}+Shift+c" = "reload";
                    "${modifier}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";
                    "${modifier}+d" = "exec /nix/store/8wxrqw98xzvqsljb4xwyjs2f1b8k61sy-dmenu-5.2/bin/dmenu_path | /nix/store/8wxrqw98xzvqsljb4xwyjs2f1b8k61sy-dmenu-5.2/bin/dmenu | /nix/store/sn1hi205k632b3l13dwxdwx4f0mf7ysr-findutils-4.9.0/bin/xargs swaymsg exec --";

                    "${modifier}+h" = "focus left";
                    "${modifier}+j" = "focus down";
                    "${modifier}+k" = "focus up";
                    "${modifier}+l" = "focus right";
                    "${modifier}+a" = "focus parent";
                    "${modifier}+space" = "focus mode_toggle";

                    "${modifier}+Shift+space" = "floating toggle";
                    "${modifier}+f" = "fullscreen toggle";
                    "${modifier}+r" = "mode resize";

                    "${modifier}+b" = "splith";
                    "${modifier}+v" = "splitv";

                    "${modifier}+s" = "layout stacking";
                    "${modifier}+w" = "layout tabbed";
                    "${modifier}+e" = "layout toggle split";

                    "${modifier}+1" = "workspace number 1";
                    "${modifier}+2" = "workspace number 2";
                    "${modifier}+3" = "workspace number 3";
                    "${modifier}+4" = "workspace number 4";
                    "${modifier}+5" = "workspace number 5";
                    "${modifier}+6" = "workspace number 6";
                    "${modifier}+7" = "workspace number 7";
                    "${modifier}+8" = "workspace number 8";
                    "${modifier}+9" = "workspace number 9";

                    "${modifier}+Shift+1" = "move container to workspace number 1";
                    "${modifier}+Shift+2" = "move container to workspace number 2";
                    "${modifier}+Shift+3" = "move container to workspace number 3";
                    "${modifier}+Shift+4" = "move container to workspace number 4";
                    "${modifier}+Shift+5" = "move container to workspace number 5";
                    "${modifier}+Shift+6" = "move container to workspace number 6";
                    "${modifier}+Shift+7" = "move container to workspace number 7";
                    "${modifier}+Shift+8" = "move container to workspace number 8";
                    "${modifier}+Shift+9" = "move container to workspace number 9";
                };

		modes.resize = {
                    Escape = "mode default";
                    r = "mode default";
                    h = "resize shrink width 10 px";
                    j = "resize grow height 10 px";
                    k = "resize shrink height 10 px";
                    l = "resize grow width 10 px";
		};
	    };

            # Set Polish keyboard layout.
	    extraConfig = ''
	        input "type:keyboard" {
                    xkb_layout pl
                }

	    '' + moduleConfig.additionalConfig;
	};
    };
}
