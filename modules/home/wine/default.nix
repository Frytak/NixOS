{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.home.wine;
in

{
    options.modules.home.wine = {
        enable = lib.mkEnableOption "Wine";
    };
    
    config = lib.mkIf moduleConfig.enable {
        home.packages = [ pkgs.wineWowPackages.base ];
    };
}
