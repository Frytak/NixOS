{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.home.ranger;

    rangerDeps = with pkgs; [
        # Image preview
        ueberzugpp

        # Video/audio preview
        ffmpegthumbnailer

        # Archive preview
        atool

        # PDF preview
        poppler-utils

        # Code highlighting preview
        bat
    ];

    ranger-wrapped = pkgs.symlinkJoin {
        name = "ranger-wrapped";
        paths = [ pkgs.ranger ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
            wrapProgram $out/bin/ranger \
                --prefix PATH : ${lib.makeBinPath rangerDeps}
        '';
    };
in

{
    options.modules.home.ranger = {
        enable = lib.mkEnableOption "ranger";
    };
    
    config = lib.mkIf moduleConfig.enable {
        home.packages = [
            ranger-wrapped
        ];

        home.file.".config/ranger/rc.conf".source = ./rc.conf;
        home.file.".config/ranger/rifle.conf".source = ./rifle.conf;
        home.file.".config/ranger/scope.sh" = {
            source = ./scope.sh;
            executable = true;
        };
    };
}
