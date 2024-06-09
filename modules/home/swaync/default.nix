{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.home.swaync;
in

{
    options.modules.home.swaync = {
        enable = lib.mkEnableOption "Sway Notification Center";
    };
    
    config = lib.mkIf moduleConfig.enable {
        home.packages = [ pkgs.swaynotificationcenter ];
    };
}
