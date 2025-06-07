{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.home.eww;
in

{
    options.modules.home.eww = {
        enable = lib.mkEnableOption "Eww (ElKowars wacky widgets)";
    };
    
    config = lib.mkIf moduleConfig.enable {
        home.packages = with pkgs; [ eww ];

        home.file.".config/eww/eww.yuck".source = ./eww.yuck;
        home.file.".config/eww/eww.scss".source = ./eww.scss;

        home.file.".config/eww/overlay.yuck".source = ./overlay.yuck;
        home.file.".config/eww/music.yuck".source = ./music.yuck;
        home.file.".config/eww/power.yuck".source = ./power.yuck;

        home.file.".config/eww/focused-screen.sh" = {
            executable = true;
            text = "hyprctl monitors -j | ${pkgs.jq}/bin/jq '.[] | select(.focused == true) | .id'";
        };

        home.file.".config/eww/dashboard.sh" = {
            executable = true;
            source = ./dashboard.sh;
        };

        home.file.".config/eww/variables.sh" = {
            executable = true;
            source = ./variables.sh;
        };
    };
}
