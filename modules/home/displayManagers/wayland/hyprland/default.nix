{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.home.displayManagers.wayland.hyprland;
in

{
    options.modules.home.displayManagers.wayland.hyprland = {
        enable = lib.mkEnableOption "Hyprland";

        extraConfig = lib.mkOption {
            description = "Extra Lua config appended to the Hyprland config.";
            type = lib.types.lines;
            default = "";
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
    };
    
    config = lib.mkIf moduleConfig.enable {
        home.packages = with pkgs; [
            pamixer
            playerctl
            hyprpolkitagent
        ]
        ++ (if (moduleConfig.grimblast.enable) then [ pkgs.grimblast ] else []);

        wayland.windowManager.hyprland = {
            enable = true;
            configType = "lua";
            xwayland.enable = true;

            # https://wiki.hyprland.org/Useful-Utilities/Systemd-start/#uwsm
            systemd.enable = false;

            # set the Hyprland and XDPH packages to null to use the ones from the NixOS module (https://wiki.hyprland.org/Nix/Hyprland-on-Home-Manager/#using-the-home-manager-module-with-nixos)
            package = null;
            portalPackage = null;

            extraConfig = ''
                local mod = "SUPER"

                -- Settings
                hl.config({
                    general = {
                        gaps_in = 5,
                        gaps_out = 5,
                        border_size = 1,
                        ["col.active_border"] = "rgba(33ccffee)",
                        ["col.inactive_border"] = "rgba(595959aa)",
                        resize_on_border = true,
                        extend_border_grab_area = 30,
                    },
                    decoration = {
                        rounding = 5,
                    },
                    input = {
                        kb_layout = "pl",
                        numlock_by_default = true,
                        follow_mouse = 2,
                        repeat_rate = 40,
                        repeat_delay = 400,
                    },
                    misc = {
                        initial_workspace_tracking = 2,
                        disable_splash_rendering = true,
                        disable_hyprland_logo = true,
                        middle_click_paste = false,
                    },
                })

                -- Autostart
                hl.on("hyprland.start", function()
                    hl.exec_cmd("systemctl --user start hyprpolkitagent")
                end)

                -- Mouse bindings
                hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
                hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

                -- Key bindings
                hl.bind(mod .. " + RETURN", hl.dsp.exec_cmd("uwsm app -- alacritty"))
                hl.bind(mod .. " + SHIFT + Q", hl.dsp.window.close())
                hl.bind(mod .. " + SHIFT + SPACE", hl.dsp.window.float({ action = "toggle" }))
                hl.bind(mod .. " + SHIFT + F11", hl.dsp.window.fullscreen({ mode = 0 }))

                -- Focus movement
                hl.bind(mod .. " + H", hl.dsp.focus({ direction = "left" }))
                hl.bind(mod .. " + J", hl.dsp.focus({ direction = "down" }))
                hl.bind(mod .. " + K", hl.dsp.focus({ direction = "up" }))
                hl.bind(mod .. " + L", hl.dsp.focus({ direction = "right" }))

                -- Audio and Media keys
                hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pamixer -i 5"), { repeating = true })
                hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pamixer -d 5"), { repeating = true })
                hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pamixer -t"))
                hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("pamixer --default-source -m"))
                hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
                hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"))
                hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
                hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))

                hl.bind(mod .. " + F3", hl.dsp.exec_cmd("pamixer -i 5"), { repeating = true })
                hl.bind(mod .. " + F2", hl.dsp.exec_cmd("pamixer -d 5"), { repeating = true })
                hl.bind(mod .. " + F1", hl.dsp.exec_cmd("pamixer -t"))
                hl.bind(mod .. " + F4", hl.dsp.exec_cmd("pamixer --default-source -t"))
                hl.bind(mod .. " + F6", hl.dsp.exec_cmd("playerctl play-pause"))
                hl.bind(mod .. " + F7", hl.dsp.exec_cmd("playerctl next"))
                hl.bind(mod .. " + F5", hl.dsp.exec_cmd("playerctl previous"))
                
                -- Regular workspaces mapping
                local ws_keys = {
                    { key = "1", code = "87" }, { key = "2", code = "88" },
                    { key = "3", code = "89" }, { key = "4", code = "83" },
                    { key = "5", code = "84" }, { key = "6", code = "85" },
                }

                for _, ws in ipairs(ws_keys) do
                    -- Focus
                    hl.bind(mod .. " + " .. ws.key, hl.dsp.focus({ workspace = "name:" .. ws.key }))
                    hl.bind(mod .. " + code:" .. ws.code, hl.dsp.focus({ workspace = "name:" .. ws.key }))

                    -- Move
                    hl.bind(mod .. " + SHIFT + " .. ws.key, hl.dsp.window.move({ workspace = "name:" .. ws.key }))
                    hl.bind(mod .. " + SHIFT + code:" .. ws.code, hl.dsp.window.move({ workspace = "name:" .. ws.key }))
                end

                -- Special workspace rules
                local special_workspaces = { "7", "8", "9", "S" }
                for _, ws in ipairs(special_workspaces) do
                    hl.workspace_rule({
                        workspace = "special:" .. ws,
                        gaps_in = 25,
                        gaps_out = 50,
                    })
                end

                -- Special workspaces mappings
                local special_keys = {
                    { key = "S", code = nil },
                    { key = "7", code = "79" },
                    { key = "8", code = "80" },
                    { key = "9", code = "81" },
                }

                for _, sp in ipairs(special_keys) do
                    hl.bind(mod .. " + " .. sp.key, hl.dsp.workspace.toggle_special(sp.key))
                    hl.bind(mod .. " + SHIFT + " .. sp.key, hl.dsp.window.move({ workspace = "special:" .. sp.key }))
                    
                    if sp.code then
                        hl.bind(mod .. " + code:" .. sp.code, hl.dsp.workspace.toggle_special(sp.key))
                        hl.bind(mod .. " + SHIFT + code:" .. sp.code, hl.dsp.window.move({ workspace = "special:" .. sp.key }))
                    end
                end
            '' + lib.optionalString moduleConfig.grimblast.enable ''
                -- Grimblast
                hl.bind(mod .. " + code:107", hl.dsp.exec_cmd("uwsm app -- grimblast copy output"))
                hl.bind(mod .. " + SHIFT + code:107", hl.dsp.exec_cmd("uwsm app -- grimblast copy screen"))
                hl.bind(mod .. " + F", hl.dsp.exec_cmd("uwsm app -- grimblast copy area"))
                hl.bind(mod .. " + SHIFT + F", hl.dsp.exec_cmd("uwsm app -- grimblast copy active"))
            '' + "\n" + moduleConfig.extraConfig;
        };
    }; 
}
