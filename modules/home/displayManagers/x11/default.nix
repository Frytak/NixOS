{ options, config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.x11;
in

{
    options.modules.x11 = {
        enable = lib.mkEnableOption "x11";
    };
    
    config = lib.mkIf moduleConfig.enable {
        xsession = {
	    enable = true;
            windowManager.i3.enable = true;
	};

        #services.xserver = {
        #    enable = true;
        #    windowManager.i3.enable = true;
        #    
        #    # Configure keymaps.
        #    xkb = {
        #        layout = "pl";
        #        options = "eurosign:e,caps:escape";
        #    };
        #};
    };
}
