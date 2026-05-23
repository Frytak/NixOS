{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.system.hyprland;
in

{
    options.modules.system.hyprland = {
        enable = lib.mkEnableOption "Hyprland";
    };

    config = lib.mkIf moduleConfig.enable {
        programs.uwsm = {
            enable = true;
            waylandCompositors.hyprland = {
              prettyName = "Hyprland";
              comment = "Hyprland compositor managed by UWSM";
              binPath = "/run/current-system/sw/bin/Hyprland";
            };
        };

        programs.hyprland = {
            enable = true;
            withUWSM = true;
        };

        environment.systemPackages = with pkgs; [ wl-clipboard ];

        xdg.portal = {
            enable = true;
            xdgOpenUsePortal = true;
            config.common.default = "*";
            extraPortals = with pkgs; [
                xdg-desktop-portal-hyprland
                xdg-desktop-portal-wlr
            ];
        };
    };
}
