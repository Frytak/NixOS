# Default configuration for all users of this device
{ inputs, pkgs, ...}:

{
    imports = [ ../../modules/home ];

    home.packages = with pkgs; [
        xdg-utils # For apps to be able to interact with XDG
        swaynotificationcenter
        wl-kbptr
        wlrctl
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

    modules.home.displayManagers.wayland.hyprland.config = {
        # Add submaps
        extraConfig = ''
            bind = $mod, m, submap, kbptr

            submap = kbptr

            bind = , p, exec, hyprctl dispatch submap reset && wl-kbptr && hyprctl dispatch submap kbptr

            binde = CTRL, j, exec, wlrctl pointer move 0 1
            binde = CTRL, k, exec, wlrctl pointer move 0 -1
            binde = CTRL, l, exec, wlrctl pointer move 1 0
            binde = CTRL, h, exec, wlrctl pointer move -1 0

            binde = , j, exec, wlrctl pointer move 0 10
            binde = , k, exec, wlrctl pointer move 0 -10
            binde = , l, exec, wlrctl pointer move 10 0
            binde = , h, exec, wlrctl pointer move -10 0

            binde = , u, exec, wlrctl pointer click left
            binde = , i, exec, wlrctl pointer click middle
            binde = , o, exec, wlrctl pointer click right

            binde = SHIFT, J, exec, wlrctl pointer move 0 100
            binde = SHIFT, K, exec, wlrctl pointer move 0 -100
            binde = SHIFT, L, exec, wlrctl pointer move 100 0
            binde = SHIFT, H, exec, wlrctl pointer move -100 0

            bind = , ESCAPE, submap, reset

            submap = reset
        '';

        settings = {
            input = {
                sensitivity = -0.8;
                touchpad = {
                    natural_scroll = true;
                };
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
                ''uwsm app -- eww open-many bar:"eDP-1" --arg "eDP-1":workspaces='["1", "2", "3", "4", "5", "6"]' --arg "eDP-1":monitor="eDP-1"''
                "[workspace special:S silent] firefox-nightly"
            ];
        };
    };
}
