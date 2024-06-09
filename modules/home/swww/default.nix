{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.home.swww;
in

{
    options.modules.home.swww = {
        enable = lib.mkEnableOption "SWWW";
    };
    
    config = lib.mkIf moduleConfig.enable {
        home.packages = [ pkgs.swww ];
    };
}
