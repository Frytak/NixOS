{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.system.networking;
in

{
    options.modules.system.networking = {
        enable = lib.mkEnableOption "system networking";
    };
    
    config = lib.mkIf moduleConfig.enable {
        networking.networkmanager.enable = true;
    };
}
