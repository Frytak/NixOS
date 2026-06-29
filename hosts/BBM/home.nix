# Default configuration for all users of this device
{ config, pkgs, ...}:

{
    imports = [ ../../modules/home ];

    home.packages = with pkgs; [
        xdg-utils # For apps to be able to interact with XDG
        swaynotificationcenter
        wayvnc
    ];

    modules.home.displayManagers.wayland.hyprland.extraConfig = ''
        hl.config({
            input = {
                sensitivity = -0.8,
                tablet = {
                    output = "current",
                },
            },
        })

        hl.monitor({ output = "HDMI-A-2", mode = "1920x1080@60", position = "0x0", scale = 1, })
        hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@60", position = "1920x0", scale = 1, })

        local monitor_workspace_rules = {
            ["HDMI-A-1"] = { "name:1", "name:2", "name:3" },
            ["HDMI-A-2"] = { "name:4", "name:5", "name:6" },
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
            hl.exec_cmd("[workspace name:4 silent] uwsm app -- nvidia-offload firefox")
            hl.exec_cmd("uwsm app -- wayvnc")
        end)
    '';
}
