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

    modules.home.displayManagers.wayland.hyprland.extraConfig = ''
        hl.config({
            input = {
                sensitivity = -0.8,
                touchpad = {
                    natural_scroll = true,
                },
                tablet = {
                    output = "current",
                },
            },

            xwayland = {
                force_zero_scaling = true,
            },
        })

        hl.monitor({ output = "eDP-1", mode = "1920x1080@60", position = "0x0", scale = 1, })

        local monitor_workspace_rules = {
            ["eDP-1"] = { "name:1", "name:2", "name:3", "name:4", "name:5", "name:6" },
        }

        for monitor, workspaces in pairs(monitor_workspace_rules) do
            for i, workspace in ipairs(workspaces) do
            hl.workspace_rule({
                workspace = workspace,
                monitor = monitor,
                persistent = true,
                default = (i == 1),
            })
            end
        end

        hl.on("hyprland.start", function() 
            hl.exec_cmd("[workspace special:S silent] uwsm app -- nvidia-offload firefox")
            hl.exec_cmd("uwsm app -- wayvnc")
        end)

        hl.bind("MOD + M", hl.dsp.submap("kbptr"))

        hl.define_submap("kbptr", function ()
            hl.bind("p", hl.dsp.exec_cmd("hyprctl dispatch submap reset && wl-kbptr && hyprctl dispatch submap kbptr"))

            hl.bind("CTRL + j", hl.dsp.exec_cmd("wlrctl pointer move 0 1"))
            hl.bind("CTRL + k", hl.dsp.exec_cmd("wlrctl pointer move 0 -1"))
            hl.bind("CTRL + l", hl.dsp.exec_cmd("wlrctl pointer move 1 0"))
            hl.bind("CTRL + h", hl.dsp.exec_cmd("wlrctl pointer move -1 0"))

            hl.bind("j", hl.dsp.exec_cmd("wlrctl pointer move 0 10"))
            hl.bind("k", hl.dsp.exec_cmd("wlrctl pointer move 0 -10"))
            hl.bind("l", hl.dsp.exec_cmd("wlrctl pointer move 10 0"))
            hl.bind("h", hl.dsp.exec_cmd("wlrctl pointer move -10 0"))

            hl.bind("u", hl.dsp.exec_cmd("wlrctl pointer click left"))
            hl.bind("i", hl.dsp.exec_cmd("wlrctl pointer click middle"))
            hl.bind("o", hl.dsp.exec_cmd("wlrctl pointer click right"))

            hl.bind("SHIFT + J", hl.dsp.exec_cmd("wlrctl pointer move 0 100"))
            hl.bind("SHIFT + K", hl.dsp.exec_cmd("wlrctl pointer move 0 -100"))
            hl.bind("SHIFT + L", hl.dsp.exec_cmd("wlrctl pointer move 100 0"))
            hl.bind("SHIFT + H", hl.dsp.exec_cmd("wlrctl pointer move -100 0"))

            hl.bind("ESCAPE", hl.dsp.submap("reset"))
        end)
    '';
}
