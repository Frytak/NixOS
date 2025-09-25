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
                material-symbols
                nerd-fonts.jetbrains-mono
            ];

            fontconfig.defaultFonts = {
                monospace = [ "JetBrainsMono Nerd Font" ];
            };
        };
    };
}
