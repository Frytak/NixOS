{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.home.alacritty;
in

{
    options.modules.home.alacritty = {
        enable = lib.mkEnableOption "alacritty";
    };
    
    config = lib.mkIf moduleConfig.enable {
        home.packages = [ pkgs.alacritty ];
    };
}
