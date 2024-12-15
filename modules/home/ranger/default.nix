{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.home.ranger;
in

{
    options.modules.home.ranger = {
        enable = lib.mkEnableOption "ranger";
    };
    
    config = lib.mkIf moduleConfig.enable {
        home.packages = with pkgs; [
            ranger
            imagemagick
        ];

        home.file.".config/ranger/rc.conf".source = ./rc.conf;
    };
}
