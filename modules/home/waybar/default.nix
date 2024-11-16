{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.home.waybar;
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
    options.modules.home.waybar = {
        enable = lib.mkEnableOption "Waybar";

        config = lib.mkOption {
            description = "Additional Waybar config added to `wayland.windowManager.hyprland` with `lib.attrsets.recursiveUpdate`.";
            type = lib.types.attrs;
            default = {};
        };
    };
    
    config = lib.mkIf moduleConfig.enable {
        programs.waybar = recursiveMerge [{
            enable = true;

            settings = {
                mainBar = {
                    layer = "bottom";
                    position = "top";
                    height = 30;

                    modules-left = [ "hyprland/workspaces" "tray" ];
                    modules-center = [ "clock" ];
                    modules-right = [ "pulseaudio" "keyboard-state" "network" "disk" ];

                    "hyprland/workspaces" = {
                        sort-by = "name";
                    };

                    "tray" = {
                        spacing = 4;
                    };

                    "clock" = {
                        interval = 5;
                        timezone = "Europe/Warsaw";

                        format = "{:%H:%M:%S}  ";
                        format-alt = "{:%A   %d.%m.%Y} 󰃭 ";

                        tooltip-format = "<tt><small>{calendar}</small></tt>";

                        calendar = {
                            mode = "year";
                            mode-mon-col = 4;
                            format = {
                                months = "<span color='#21bfa7'><b>{}</b></span>";
                                weekdays = "<span color='#1d8f7d'><b>{}</b></span>";
                                today = "<span color='#cf1e0e'><b><u>{}</u></b></span>";
                            };
                        };

                        actions = {
                            on-click-right = "mode";
                        };
                    };

                    "pulseaudio" = {
                        format = "{volume}%  ";
                        format-muted = "{volume}%  ";
                        states = {
                            "off" = 0;
                            "low" = 50;
                            "high" = 100;
                        };

                        format-off = "{volume}%  ";
                        format-low = "{volume}%  ";
                        format-high = "{volume}%  ";
                    };

                    "network" = {
                        format-wifi = "{essid} ({frequency}GHz)  ";
                        tooltip-format = "Up: {bandwidthUpBytes}   Down: {bandwidthDownBytes}";
                    };

                    "disk" = {
                        format = "{used} / {total}  ";
                        tooltip-format = "{percentage_used}% of the disk used.";
                    };
                };
            };

            style = ''
                * {
                    padding: 0;
                    margin: 0;
                    border: none;
                    box-shadow: inset 0 0 rgba(0, 0, 0, 0);
                    border-radius: 0;
                    min-height: 0;
                    color: #f0f0f0;
                }

                *:hover {
                    background: initial;
                }

                tooltip, #tray menu {
                    background-color: rgba(26, 26, 26, 0.95);
                    border: solid;
                    border-color: rgba(10, 10, 10, 0.95);
                    border-width: 2px;
                    border-radius: 6px;
                }

                window#waybar {
                    background-color: rgba(26, 26, 26, 0.8);
                }

                #tray {
                    margin: 3px;
                    padding: 4px;

                    border-top: solid;
                    border-bottom: solid;
                    border-color: rgba(10, 10, 10, 0.8);
                    border-width: 2px;
                    border-radius: 6px;

                    background-color: rgba(26, 26, 26, 0.8);
                }

                #workspaces button {
                    margin-top: 3px;
                    margin-bottom: 3px;
                    padding: 4px;

                    border-top: solid;
                    border-bottom: solid;
                    border-color: rgba(10, 10, 10, 0.8);
                    border-width: 2px;

                    background-color: rgba(26, 26, 26, 0.8);
                }

                #workspaces > button:first-child {
                    margin-left: 3px;
                    border-top-left-radius: 6px;
                    border-bottom-left-radius: 6px;
                }

                #workspaces > button:last-child {
                    margin-right: 3px;
                    border-top-right-radius: 6px;
                    border-bottom-right-radius: 6px;
                }

                #workspaces button:hover {
                    background-color: rgba(46, 46, 46, 0.8);
                }

                #workspaces button.active {
                    color: #0a0a0a;
                    background-color: #21bfa7;
                }

                #workspaces button.acitve:hover {
                    background-color: #21bfa7;
                }

                #clock {
                    margin-top: 3px;
                    margin-bottom: 3px;
                    padding: 4px;

                    background-color: rgba(26, 26, 26, 0.8);

                    border-top: solid;
                    border-bottom: solid;
                    border-color: rgba(10, 10, 10, 0.8);
                    border-width: 2px;
                    border-radius: 6px;
                }

                #pulseaudio, #network, #disk {
                    margin: 3px;
                    padding: 4px;

                    background-color: rgba(26, 26, 26, 0.8);

                    border-top: solid;
                    border-bottom: solid;
                    border-color: rgba(10, 10, 10, 0.8);
                    border-width: 2px;
                    border-radius: 6px;
                }
            '';
        } moduleConfig.config];
    };
}
