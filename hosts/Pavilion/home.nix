# Default configuration for all users of this device
{ inputs, pkgs, ...}:

{
    imports = [ ../../modules/home ];

    home.packages = with pkgs; [
        xdg-utils # For apps to be able to interact with XDG
        swaynotificationcenter
    ];

    modules.home.waybar.config = {
        settings.mainBar = {
            output = [ "eDP-1" ];
            modules-right = [ "backlight" "battery" ];

            "hyprland/workspaces".persistent-workspaces = {
                "eDP-1" = [ 1 2 3 4 5 6 ];
            };
        };
    };

    modules.home.displayManagers.wayland.hyprland.config.settings = {
        input = {
            sensitivity = -0.8;
        };

        xwayland = {
            force_zero_scaling = true;
        };

        monitor = [
            "eDP-1, 1920x1080@60, 0x0, 1"
        ];

        workspace = [
            "name:1, monitor:eDP-1, default:true"
            "name:2, monitor:eDP-1"
            "name:3, monitor:eDP-1"
            "name:4, monitor:eDP-1"
            "name:5, monitor:eDP-1"
            "name:6, monitor:eDP-1"
        ];

        exec-once = [
            "[workspace special:S silent] firefox-nightly"
        ];
    };
}
