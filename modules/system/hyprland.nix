{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.system.hyprland;
in

{
    options.modules.system.hyprland = {
        enable = lib.mkEnableOption "Hyprland";
    };

    config = lib.mkIf moduleConfig.enable {
        programs.hyprland.enable = true;

        environment.systemPackages = with pkgs; [ wl-clipboard ];

        xdg.portal = {
            enable = true;
            xdgOpenUsePortal = true;
            config.common.default = "*";
            extraPortals = with pkgs; [
                xdg-desktop-portal-hyprland
                xdg-desktop-portal-gtk
            ];
        };
    };
}
