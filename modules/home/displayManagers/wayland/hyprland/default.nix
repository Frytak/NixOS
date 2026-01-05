{ config, lib, pkgs, recursiveMerge, inputs, ... }:

let
    moduleConfig = config.modules.home.displayManagers.wayland.hyprland;
    # God bless them https://stackoverflow.com/a/54505212/16454500
    recursiveMerge = attrList:
    let f = attrPath:
        lib.zipAttrsWith (n: values:
            if lib.tail values == []
                then lib.head values
            else if lib.all lib.isList values
                then lib.unique (lib.concatLists values)
            else if lib.all lib.isAttrs values
                then f (attrPath ++ [n]) values
            else lib.last values
        );
    in f [] attrList;
in

{
    options.modules.home.displayManagers.wayland.hyprland = {
        enable = lib.mkEnableOption "Hyprland";

        config = lib.mkOption {
            description = "Additional Hyprland config added to `wayland.windowManager.hyprland` with `lib.attrsets.recursiveUpdate`.";
            type = lib.types.attrs;
            default = {};
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
    };
    
    config = lib.mkIf moduleConfig.enable {
        home.packages = with pkgs; [
            pamixer
            playerctl
            hyprpolkitagent
        ]
        ++ (if (moduleConfig.grimblast.enable) then ([ pkgs.grimblast ]) else ([]));

        wayland.windowManager.hyprland = recursiveMerge [{
            enable = true;
            xwayland.enable = true;

            # https://wiki.hyprland.org/Useful-Utilities/Systemd-start/#uwsm
            systemd.enable = false;

            # set the Hyprland and XDPH packages to null to use the ones from the NixOS module (https://wiki.hyprland.org/Nix/Hyprland-on-Home-Manager/#using-the-home-manager-module-with-nixos)
            package = null;
            portalPackage = null;

            settings = {
                debug.disable_logs = false;
                "$mod" = "SUPER";

                exec-once = [
                    "systemctl --user import-environment XDG_SESSION_TYPE XDG_CURRENT_DESKTOP"
                    "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
                    "systemctl --user start hyprpolkitagent"
                    "uwsm app -- swaync"
                    "[workspace special:7 silent] uwsm app -- vesktop"
                    "[workspace special:8 silent] uwsm app -- Telegram"
                ];

                bindm = [
                    "$mod, mouse:272, movewindow"
                    "$mod, mouse:273, resizewindow"
                ];

                bind = [
                    # Launching apps
                    "$mod, D, exec, uwsm app -- tofi-run | xargs hyprctl dispatch exec uwsm app --"
                    "$mod, RETURN, exec, uwsm app -- alacritty"

                    # Moving focus
                    "$mod, h, movefocus, l"
                    "$mod, j, movefocus, d"
                    "$mod, k, movefocus, u"
                    "$mod, l, movefocus, r"

                    # Others
                    "$mod SHIFT, Q, killactive"
                    "$mod SHIFT, SPACE, togglefloating"
                    "$mod SHIFT, F11, fullscreen, 0"

                    ", XF86AudioRaiseVolume, exec, pamixer -i 5"
                    ", XF86AudioLowerVolume, exec, pamixer -d 5"
                    ", XF86AudioMute, exec, pamixer -t"
                    ", XF86AudioMicMute, exec, pamixer --default-source -m"
                    ", XF86AudioPlay, exec, playerctl play-pause"
                    ", XF86AudioPause, exec, playerctl play-pause"
                    ", XF86AudioNext, exec, playerctl next"
                    ", XF86AudioPrev, exec, playerctl previous"

                    "$mod, F3, exec, pamixer -i 5"
                    "$mod, F2, exec, pamixer -d 5"
                    "$mod, F1, exec, pamixer -t"
                    "$mod, F4, exec, pamixer --default-source -t"
                    "$mod, F6, exec, playerctl play-pause"
                    "$mod, F7, exec, playerctl next"
                    "$mod, F5, exec, playerctl previous"

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
                    "$mod, S, togglespecialworkspace, S"
                    "$mod SHIFT, S, movetoworkspace, special:S"

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

                    # Eww overlay
                    "$mod, W, exec, ${config.home.homeDirectory}/.config/eww/dashboard.sh"
                ]
                ++ (if (moduleConfig.grimblast.enable) then ([
                    "$mod, code:107, exec, uwsm app -- grimblast copy output"
                    "$mod SHIFT, code:107, exec, uwsm app -- grimblast copy screen"
                    "$mod, F, exec, uwsm app -- grimblast copy area"
                    "$mod SHIFT, F, exec, uwsm app -- grimblast copy active"
                ]) else ([]));

                windowrulev2 = [
                    "workspace special:7 silent, initialClass:(vesktop)"
                ];

                workspace = [
                    "special:7, gapsin:25, gapsout:50"
                    "special:8, gapsin:25, gapsout:50"
                    "special:9, gapsin:25, gapsout:50"
                    "special:S, gapsin:25, gapsout:50"
                ];

                general = {
                    gaps_in = 5;
                    gaps_out = 5;
                    border_size = 1;

                    "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
                    "col.inactive_border" = "rgba(595959aa)";

                    resize_on_border = true;
                    extend_border_grab_area = 30;
                };

                decoration = {
                    rounding = 5;
                };

                input = {
                    kb_layout = "pl";
                    numlock_by_default = true;
                    follow_mouse = 2;

                    repeat_rate = 40;
                    repeat_delay = 400;
                };

                misc = {
                    initial_workspace_tracking = 2;
                    disable_splash_rendering = true;
                    disable_hyprland_logo = true;
                    middle_click_paste = false;
                };
            };
        } moduleConfig.config];
    };
}
