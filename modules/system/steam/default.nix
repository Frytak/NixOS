{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.system.steam;
in

{
    options.modules.system.steam = {
        enable = lib.mkEnableOption "steam";
    };
    
    config = lib.mkIf moduleConfig.enable {
        programs.steam = {
            enable = true;
            remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
            dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
            gamescopeSession.enable = true;
        };

        programs.gamemode.enable = true;
    };
}
