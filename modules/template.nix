{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.MODULE;
in

{
    options.modules.MODULE = {
        enable = lib.mkEnableOption "MODULE";
    };
    
    config = lib.mkIf moduleConfig.enable {
    };
}
