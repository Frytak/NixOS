{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.home.fish;
in

{
    options.modules.home.fish = {
        enable = lib.mkEnableOption "fish shell";
    };
    
    config = lib.mkIf moduleConfig.enable {
        home.packages = [ pkgs.fishPlugins.bass ];
        programs.fish = {
            enable = true;
        };
    };
}
