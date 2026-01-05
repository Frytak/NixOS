{ config, lib, pkgs, unstablePkgs, ... }:

let
    moduleConfig = config.modules.home.rmpc;

    download-music = pkgs.stdenv.mkDerivation rec {
        name = "download-music";
        src = ./download-music.sh;
        buildInputs = [ pkgs.makeWrapper ];
        phases = [ "installPhase" ];
        installPhase = ''
            mkdir -p $out/bin
            cp $src $out/bin/${name}.sh
            chmod +x $out/bin/${name}.sh
            wrapProgram $out/bin/${name}.sh --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.yt-dlp (pkgs.python3.pkgs.beets.override { disableAllPlugins = true; }) ]}
        '';
    };
in

{
    options.modules.home.rmpc = {
        enable = lib.mkEnableOption "rmpc";
        enableMpd = lib.mkEnableOption "mpd";

        theme = lib.mkOption {
            description = "Theme for RMPC";
            type = lib.types.str;
            default = "frytak";
        };
    };

    config = lib.mkIf moduleConfig.enable {
        home.packages = [
            pkgs.mpc
            unstablePkgs.rmpc
        ];

        # TODO: add https://github.com/natsukagami/mpd-mpris
        services.mpd = lib.mkIf moduleConfig.enableMpd {
            enable = true;
            dataDir = "${config.home.homeDirectory}/Music/.mpd";
            musicDirectory = "${config.home.homeDirectory}/Music";
            extraConfig = ''
                auto_update "yes"
                audio_output {
                    type "pipewire"
                    name "PipeWire Output"
                    mixer_type "software"
                }
            '';
        };

        home.file.".config/rmpc/config.ron".source = pkgs.replaceVars ./config.ron.template {
            theme = moduleConfig.theme;
            lyricsDirectory = "${config.home.homeDirectory}/Music";
        };

        home.file.".config/rmpc/themes/frytak.ron".source = ./themes/frytak.ron;

        home.file."Music/download-music.sh" = {
            executable = true;
            source = "${download-music}/bin/download-music.sh";
        };

        home.activation.createMusicDownloadsDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
            mkdir -p ${config.home.homeDirectory}/Music/downloads
        '';
    };
}
