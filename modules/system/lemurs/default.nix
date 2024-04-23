{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.system.lemurs;
    tty = "tty1";
in

{
    options.modules.system.lemurs = {
        enable = lib.mkEnableOption "lemurs";
    };
    
    config = lib.mkIf moduleConfig.enable {
        # Enable lemurs.
        environment.systemPackages = [ pkgs.lemurs ];

	# Add lemurs to init.
        systemd.services.lemurs = {
	
	    #wantedBy = ["multi-user.target"];
	    #unitConfig = {
            #    Wants = [ "systemd-user-sessions.service" ];
	    #    After = [ "systemd-user-sessions.service" "getty@${tty}.service" ];
	    #    Conflicts = [ "getty@${tty}.service" ];
	    #};

            #serviceConfig = {
            #    ExecStart = "lemurs";
            #    
            #    IgnoreSIGPIPE = false;
            #    SendSIGHUP = true;
            #    TimeoutStopSec = "30s";
            #    KeyringMode = "shared";
            #    
            #    Type = "idle";
            #};
	};

	# Set up configuration.
	environment.etc."/lemurs/wayland/sway".source = ./sway;
	environment.etc."/lemurs/config.toml".source = ./sway;
    };
}
