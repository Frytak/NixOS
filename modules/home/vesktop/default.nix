{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.home.vesktop;
in

{
    options.modules.home.vesktop = {
        enable = lib.mkEnableOption "Vesktop";
    };
    
    config = lib.mkIf moduleConfig.enable {
        home.packages = [ pkgs.vesktop ];
    };
}
