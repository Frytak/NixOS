{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.system.mgba;
in

{
    options.modules.system.mgba = {
        enable = lib.mkEnableOption "mgba";
    };
    
    config = lib.mkIf moduleConfig.enable {
        environment.systemPackages = [ pkgs.mgba ];
    };
}
