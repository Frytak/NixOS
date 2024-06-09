{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.home.terminals.alacritty;
in

{
    options.modules.home.terminals.alacritty = {
        enable = lib.mkEnableOption "alacritty";
    };
    
    config = lib.mkIf moduleConfig.enable {
        home.packages = [ pkgs.alacritty ];
    };
}
