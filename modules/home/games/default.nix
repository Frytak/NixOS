{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.home.games;
in

{
    imports = [
        ./prismlauncher
    ];

    options.modules.home.games = {
        enable = lib.mkEnableOption "games";
    };
    
    config = lib.mkIf moduleConfig.enable {
        home.packages = with pkgs; [
            protonup
            lutris
            bottles
        ];

        home.sessionVariables = {
            STEAM_EXTRA_COMPAT_TOOLS_PATH = "\${HOME}/.steam/root/compatibilitytools.d";
        };
    };
}
