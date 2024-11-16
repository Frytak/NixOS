{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.system.fonts;
in

{
    options.modules.system.fonts = {
        enable = lib.mkEnableOption "Default fonts";
    };

    config = lib.mkIf moduleConfig.enable {
        fonts = {
            packages = with pkgs; [
                (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
            ];

            fontconfig.defaultFonts = {
                monospace = [ "JetBrainsMono Nerd Font" ];
            };
        };
    };
}
