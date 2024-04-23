{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.system.fonts;
in

{
    # TODO
    options.modules.system.fonts = {
        enable = lib.mkEnableOption "system fonts";
    };
    
    config = lib.mkIf moduleConfig.enable {
        fonts = {
            packages = with pkgs; [
                jetbrains-mono
                (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
            ];

            fontconfig = {
                hinting.autohint = true;
                defaultFonts = {
                    emoji = [ "OpenMoji Color" ];
            	    monospace = [ "JetBrainsMono" ];
                };
            };
        };
    };
}
