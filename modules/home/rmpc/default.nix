{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.home.rmpc;
in

{
    options.modules.home.rmpc = {
        enable = lib.mkEnableOption "rmpc";
        enableMpd = lib.mkEnableOption "mpd";
        enableMpdMpris = lib.mkEnableOption "mpd-mpris";

        theme = lib.mkOption {
            description = "Theme for RMPC";
            type = lib.types.str;
            default = "frytak";
        };
    };

    config = lib.mkIf moduleConfig.enable {
        home.packages = with pkgs; [
            mpc
            unstable.rmpc
        ];

        services.mpd-mpris = lib.mkIf moduleConfig.enableMpdMpris {
            enable = true;
        };

        services.mpd = lib.mkIf moduleConfig.enableMpd {
            enable = true;
            dataDir = "${config.home.homeDirectory}/Music/.mpd";
            musicDirectory = "${config.home.homeDirectory}/Music";
            extraConfig = ''
                # Bind to a Unix socket for local, privileged client access
                bind_to_address "${config.home.homeDirectory}/Music/.mpd/socket"

                auto_update "yes"
                audio_output {
                    type "pipewire"
                    name "PipeWire Output"
                    mixer_type "software"
                }
                input_cache {
                    size "1 GB"
                }
            '';
        };

        home.sessionVariables = {
            MPD_HOST = lib.mkForce "${config.home.homeDirectory}/Music/.mpd/socket";
        };

        home.file.".config/rmpc/config.ron".source = pkgs.replaceVars ./config.ron.template {
            theme = moduleConfig.theme;
            lyricsDirectory = "${config.home.homeDirectory}/Music";
            mpdSocket = "${config.home.homeDirectory}/Music/.mpd/socket";
        };

        home.file.".config/rmpc/themes/frytak.ron".source = ./themes/frytak.ron;
    };
}
