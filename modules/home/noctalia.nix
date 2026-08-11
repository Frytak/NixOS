{ config, lib, pkgs, inputs, ... }:

let
    moduleConfig = config.modules.home.noctalia;
in

{
    options.modules.home.noctalia = {
        enable = lib.mkEnableOption "Noctalia";

        wallpaper = lib.mkOption {
            description = "Whether to enable Noctalia wallpaper management.";
            type = lib.types.str;
            default = "";
        };
    };
    
    config = lib.mkIf moduleConfig.enable {
        programs.noctalia = {
            enable = true;

            systemd.enable = true;

            settings = {
                theme = {
                    mode = "dark";
                    source = "wallpaper";
                    wallpaper_scheme = "m3-tonal-spot";
                };

                wallpaper = {
                    enabled = true;
                    default.path = moduleConfig.wallpaper;
                    transition = [ "honeycomb" ];
                    directory = "/etc/nixos/wallpapers";
                };

                bar.main = {
                    panel_overlap = 0;

                    margin_ends = 5;
                    margin_edge = 0;

                    radius_top_left = 0;
                    radius_top_right = 0;

                    capsule = true;

                    start = ["launcher" "wallpaper" "workspaces"];
                    center = ["clock"];
                    end = ["media" "volume" "brightness" "batterty" "bluetooth" "network" "control-center" "session"];
                };

                location = {
                    address = "Stróże, Poland";
                };

                weather = {
                    enabled = true;
                };

                calendar.account.frytak_google = {
                    type = "google";
                    name = "Frytak";
                };
            };
        };

        # https://docs.noctalia.dev/v5/compositor-settings/hyprland/
        modules.home.displayManagers.wayland.hyprland.extraConfig = ''
            --hl.on("hyprland.start", function()
            --    hl.exec_cmd("uwsm app -- noctalia")
            --end)

            hl.config({
                decoration = {
                    shadow = {
                        enabled = true,
                        range = 4,
                        render_power = 3,
                        color = 0xee1a1a1a,
                    },

                    blur = {
                        enabled = true,
                        size = 3,
                        passes = 2,
                        vibrancy = 0.1696,
                    },
                },
            })

            hl.layer_rule({
                name = "noctalia",
                match = {
                    namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd)$",
                },
                no_anim = true,
                ignore_alpha = 0.5,
                blur = true,
                blur_popups = true,
            })
        '';
    };
}
