{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.home.displayManagers.x11;
in

{
    imports = [
        ./i3
    ];

    options.modules.home.displayManagers.x11 = {
        enable = lib.mkEnableOption "X11";
    };
    
    config = lib.mkIf moduleConfig.enable {
        xsession = {
            enable = true;
            scriptPath = ".hm-xsession";
        };
    };
}
