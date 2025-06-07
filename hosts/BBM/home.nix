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
            output = [
                "HDMI-A-1"
                "HDMI-A-2"
            ];

            "hyprland/workspaces".persistent-workspaces = {
                "HDMI-A-1" = [ 1 2 3 ];
                "HDMI-A-2" = [ 4 5 6 ];
            };
        };
    };

    modules.home.displayManagers.wayland.hyprland.config.settings = {
        input = {
            sensitivity = -0.8;
        };

        monitor = [
            "HDMI-A-2, 1920x1080@60, 0x0, 1"
            "HDMI-A-1, 1920x1080@60, 1920x0, 1"
        ];

        workspace = [
            "name:1, monitor:HDMI-A-1, default:true"
            "name:2, monitor:HDMI-A-1"
            "name:3, monitor:HDMI-A-1"
            "name:4, monitor:HDMI-A-2, default:true"
            "name:5, monitor:HDMI-A-2"
            "name:6, monitor:HDMI-A-2"
        ];

        exec-once = [
            "[workspace name:4 silent] uwsm app -- firefox-nightly"
        ];
    };
}
