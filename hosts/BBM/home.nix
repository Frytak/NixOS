# Default configuration for all users of this device
{...}:

{
    imports = [ ../../modules/home ];

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
    };
}
