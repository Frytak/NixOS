{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.home.direnv;
in

{
    options.modules.home.direnv = {
        enable = lib.mkEnableOption "Direnv";
    };
    
    config = lib.mkIf moduleConfig.enable {
        programs.direnv = {
            enable = true;
        };
    };
}
