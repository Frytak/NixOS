{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.home.displayManagers.wayland.hyprland;
in

{
    options.modules.home.displayManagers.wayland.hyprland = {
        enable = lib.mkEnableOption "Hyprland";

        exec-once = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [];
        };

        grimblast.enable = lib.mkOption {
            description = "Whether to turn on configuration for Grimblast.";
            type = lib.types.bool;
            default = false;
        };

        # TODO
        swaync.enable = lib.mkOption {
            description = "Whether to turn on configuration for Sway Notification Manager.";
            type = lib.types.bool;
            default = false;
        };

        # TODO
        waybar.enable = lib.mkOption {
            description = "Whether to turn on configuration for Waybar.";
            type = lib.types.bool;
            default = false;
        };

        # TODO
        swww.enable = lib.mkOption {
            description = "Whether to turn on configuration for SWWW.";
            type = lib.types.bool;
            default = false;
        };
    };
    
    config = lib.mkIf moduleConfig.enable {
        home.packages = [ pkgs.xwaylandvideobridge ]
        ++ (if (moduleConfig.grimblast.enable) then ([ pkgs.grimblast ]) else ([]));

        wayland.windowManager.hyprland = {
            enable = true;
            systemd.enable = true;
            xwayland.enable = true;

            settings = lib.mkDefault {
                "$mod" = "SUPER";

                exec-once = [
                    "systemctl --user import-environment XDG_SESSION_TYPE XDG_CURRENT_DESKTOP"
                    "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
                    "swaync"
                    "waybar"
                    "swww-daemon"
                    "vencorddesktop"
                ] ++ moduleConfig.exec-once;

                bindm = [
                    "$mod, mouse:272, movewindow"
                ];

                bind = [
                    # Launching apps
                    "$mod, D, exec, tofi-run | xargs hyprctl dispatch exec --"
                    "$mod, RETURN, exec, alacritty"

                    # Moving focus
                    "$mod, h, movefocus, l"
                    "$mod, j, movefocus, d"
                    "$mod, k, movefocus, u"
                    "$mod, l, movefocus, r"

                    # Others
                    "$mod SHIFT, Q, killactive"
                    "$mod SHIFT, SPACE, togglefloating"
                    "$mod SHIFT, F, fullscreen, 0"

                    ", XF86AudioRaiseVolume, exec, pamixer -i 5"
                    ", XF86AudioLowerVolume, exec, pamixer -d 5"
                    ", XF86AudioMicMute, exec, pamixer --default-source -m"
                    ", XF86AudioMute, exec, pamixer -t"
                    ", XF86AudioPlay, exec, playerctl play-pause"
                    ", XF86AudioPause, exec, playerctl play-pause"
                    ", XF86AudioNext, exec, playerctl next"
                    ", XF86AudioPrev, exec, playerctl previous"

                    # TODO
                    "$mod, N, exec, swaync-client -t"

                    # Workspaces
                    "$mod, 1, workspace, name:1"
                    "$mod SHIFT, 1, movetoworkspace, name:1"
                    "$mod, code:87, workspace, name:1"
                    "$mod SHIFT, code:87, movetoworkspace, name:1"

                    "$mod, 2, workspace, name:2"
                    "$mod SHIFT, 2, movetoworkspace, name:2"
                    "$mod, code:88, workspace, name:2"
                    "$mod SHIFT, code:88, movetoworkspace, name:2"

                    "$mod, 3, workspace, name:3"
                    "$mod SHIFT, 3, movetoworkspace, name:3"
                    "$mod, code:89, workspace, name:3"
                    "$mod SHIFT, code:89, movetoworkspace, name:3"

                    "$mod, 4, workspace, name:4"
                    "$mod SHIFT, 4, movetoworkspace, name:4"
                    "$mod, code:83, workspace, name:4"
                    "$mod SHIFT, code:83, movetoworkspace, name:4"

                    "$mod, 5, workspace, name:5"
                    "$mod SHIFT, 5, movetoworkspace, name:5"
                    "$mod, code:84, workspace, name:5"
                    "$mod SHIFT, code:84, movetoworkspace, name:5"

                    "$mod, 6, workspace, name:6"
                    "$mod SHIFT, 6, movetoworkspace, name:6"
                    "$mod, code:85, workspace, name:6"
                    "$mod SHIFT, code:85, movetoworkspace, name:6"

                    # Special workspaces
                    "$mod, S, togglespecialworkspace, discord"
                    "$mod SHIFT, S, movetoworkspace, special:discord"

                    "$mod, 7, togglespecialworkspace, 7"
                    "$mod SHIFT, 7, movetoworkspace, special:7"
                    "$mod, code:79, togglespecialworkspace, 7"
                    "$mod SHIFT, code:79, movetoworkspace, special:7"

                    "$mod, 8, togglespecialworkspace, 8"
                    "$mod SHIFT, 8, movetoworkspace, special:8"
                    "$mod, code:80, togglespecialworkspace, 8"
                    "$mod SHIFT, code:80, movetoworkspace, special:8"

                    "$mod, 9, togglespecialworkspace, 9"
                    "$mod SHIFT, 9, movetoworkspace, special:9"
                    "$mod, code:81, togglespecialworkspace, 9"
                    "$mod SHIFT, code:81, movetoworkspace, special:9"
                ]
                ++ (if (moduleConfig.grimblast.enable) then ([
                    "$mod, code:107, exec, grimblast copy screen"
                    "$mod SHIFT, code:107, exec, grimblast copy output"
                    "$mod, F, exec, grimblast copy area"
                    "$mod SHIFT, F, exec, grimblast copy active"
                ]) else ([]))
                ++ (
                # Workspaces
                # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
                    builtins.concatLists (builtins.genList (
                        x: let
                            ws = let
                                c = (x + 1) / 10;
                            in
                            builtins.toString (x + 1 - (c * 10));
                        in [
                            "$mod, ${ws}, workspace, name:${toString (x + 1)}"
                            "$mod SHIFT, ${ws}, movetoworkspace, name:${toString (x + 1)}"
                        ]
                    ) 6)
                );

                workspace = [
                    "name:1, monitor:HDMI-A-2, default:true"
                    "name:2, monitor:HDMI-A-2"
                    "name:3, monitor:HDMI-A-2"
                    "name:4, monitor:HDMI-A-1, default:true"
                    "name:5, monitor:HDMI-A-1"
                    "name:6, monitor:HDMI-A-1"
                    "special:7, gapsin:5"
                    "special:8, gapsin:5"
                    "special:9, gapsin:5"
                    "special:S, gapsin:5"
                ];

                windowrule = [
                    "workspace special:S, class:(VencordDesktop)"
                ];

                # TODO: Auto detect device
                monitor = [
                    "HDMI-A-2, 1920x1080@60, 0x0, 1"
                    "HDMI-A-1, 1920x1080@60, 1920x0, 1"
                ];

                general = {
                    gaps_in = 5;
                    gaps_out = 5;
                    border_size = 1;

                    "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
                    "col.inactive_border" = "rgba(595959aa)";

                    resize_on_border = true;
                    extend_border_grab_area = 15;
                };

                decoration = {
                    rounding = 5;
                };

                input = {
                    kb_layout = "pl";
                    numlock_by_default = true;
                    follow_mouse = 2;
                };

                misc = {
                    disable_splash_rendering = true;
                };
            };
        };
    };
}
