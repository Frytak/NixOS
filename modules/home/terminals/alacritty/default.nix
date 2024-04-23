{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.terminals.alacritty;
in

{
    options.modules.terminals.alacritty = {
        enable = lib.mkEnableOption "alacritty";
    };
    
    config = lib.mkIf moduleConfig.enable {
        home.packages = [ pkgs.alacritty ];
    };
}
