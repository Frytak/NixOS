{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.home.waybar;
in

{
    options.modules.home.waybar = {
        enable = lib.mkEnableOption "Waybar";

        systemd.enable = lib.mkOption {
            description = "Whether to automatically launch Waybar via systemd.";
            type = lib.types.bool;
            default = false;
        };
    };
    
    config = lib.mkIf moduleConfig.enable {
        programs.waybar = {
            enable = true;

            systemd = lib.mkIf moduleConfig.systemd.enable {
                enable = true;
                target = "sway-session.target";
            };
        };
    };
}
