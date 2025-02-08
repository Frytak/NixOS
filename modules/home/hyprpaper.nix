{ config, lib, pkgs, self, ... }:

let
    moduleConfig = config.modules.home.hyprpaper;
in

{
    options.modules.home.hyprpaper = {
        enable = lib.mkEnableOption "Hyprpaper";

        wallpaper = lib.mkOption {
            description = "Wallpaper to use.";
            type = lib.types.str;
        };
    };
    
    config = lib.mkIf moduleConfig.enable {
        services.hyprpaper = {
            enable = true;
            settings = {
                preload = [ "${self}/wallpapers/${moduleConfig.wallpaper}" ];
                wallpaper = [ ", ${self}/wallpapers/${moduleConfig.wallpaper}" ];
            };
        };
    };
}
