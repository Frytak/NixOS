{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.home.shells.fish;
in

{
    options.modules.home.shells.fish = {
        enable = lib.mkEnableOption "fish shell";
    };
    
    config = lib.mkIf moduleConfig.enable {
        programs.fish = {
            enable = true;
        };
    };
}
