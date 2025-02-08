{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.system.network-manager;
in

{
    options.modules.system.network-manager = {
        enable = lib.mkEnableOption "Network manager";
    };

    config = lib.mkIf moduleConfig.enable {
        networking.networkmanager.enable = true;
        networking.firewall = {
            enable = true;
            allowedTCPPorts = [ 2855 ];
            allowedUDPPorts = [ 2856 ];
        };
    };
}
