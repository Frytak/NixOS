{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.home.games;
in

{
    options.modules.home.games = {
        enable = lib.mkEnableOption "games";
        steam.enable = lib.mkEnableOption "steam";
    };
    
    config = lib.mkIf moduleConfig.enable {
        home.packages = with pkgs; [
            protonup
            lutris
            bottles
        ] ++
        (if moduleConfig.steam.enable then [ pkgs.steam ] else []);

        home.sessionVariables = {
            STEAM_EXTRA_COMPAT_TOOLS_PATH = "\${HOME}/.steam/root/compatibilitytools.d";
        };
    };
}
