{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.home.foot;
in

{
    options.modules.home.foot = {
        enable = lib.mkEnableOption "foot";
    };
    
    config = lib.mkIf moduleConfig.enable {
        programs.foot = {
            enable = true;
            settings = {
                main = {
                    term = "foot";
                    font = "monospace:size=12";
                    dpi-aware = "yes";
                };

                scrollback = {
                    lines = 10000;
                    multiplier = 4.0;
                };

                colors = {
                    background = "141414";
                    foreground = "A7B7B7";
                };
            };
        };
    };
}
