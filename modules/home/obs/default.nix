{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.home.obs;
in

{
    options.modules.home.obs = {
        enable = lib.mkEnableOption "OBS";
    };
    
    config = lib.mkIf moduleConfig.enable {
        home.packages = [ pkgs.obs-studio ];
    };
}
