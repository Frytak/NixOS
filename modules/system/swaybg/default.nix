{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.system.swaybg;
in

{
    options.modules.system.swaybg = {
        enable = lib.mkEnableOption "swaybg";
    };
    
    config = lib.mkIf moduleConfig.enable {
        environment.systemPackages = [ pkgs.swaybg ];
    };
}
