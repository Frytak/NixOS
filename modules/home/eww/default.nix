{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.home.eww;

    default-connection = pkgs.stdenv.mkDerivation rec {
        name = "default-connection";
        src = ./default-connection.sh;
        buildInputs = [ pkgs.makeWrapper ];
        phases = [ "installPhase" ];
        installPhase = ''
            mkdir -p $out/bin
            cp $src $out/bin/${name}.sh
            chmod +x $out/bin/${name}.sh
            wrapProgram $out/bin/${name}.sh --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.jq pkgs.bc ]}
        '';
    };

    current-workspace = pkgs.stdenv.mkDerivation rec {
        name = "current-workspace";
        src = ./current-workspace.sh;
        buildInputs = [ pkgs.makeWrapper ];
        phases = [ "installPhase" ];
        installPhase = ''
            mkdir -p $out/bin
            cp $src $out/bin/${name}.sh
            chmod +x $out/bin/${name}.sh
            wrapProgram $out/bin/${name}.sh --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.jq pkgs.socat ]}
        '';
    };
in

{
    options.modules.home.eww = {
        enable = lib.mkEnableOption "Eww (ElKowars wacky widgets)";
    };
    
    config = lib.mkIf moduleConfig.enable {
        home.packages = with pkgs; [ eww ];

        home.file.".config/eww/eww.yuck".source = ./eww.yuck;
        home.file.".config/eww/eww.scss".source = ./eww.scss;

        home.file.".config/eww/overlay.yuck".source = ./overlay.yuck;
        home.file.".config/eww/music.yuck".source = ./music.yuck;
        home.file.".config/eww/power.yuck".source = ./power.yuck;
        home.file.".config/eww/bar.yuck".source = ./bar.yuck;

        home.file.".config/eww/focused-screen.sh" = {
            executable = true;
            text = "hyprctl monitors -j | ${pkgs.jq}/bin/jq -r 'map(select(.focused) | .name) | .[]'";
        };

        home.file.".config/eww/default-connection.sh" = {
            executable = true;
            source = "${default-connection}/bin/default-connection.sh";
        };

        home.file.".config/eww/current-workspace.sh" = {
            executable = true;
            source = "${current-workspace}/bin/current-workspace.sh";
        };

        home.file.".config/eww/time.sh" = {
            executable = true;
            source = ./time.sh;
        };

        home.file.".config/eww/dashboard.sh" = {
            executable = true;
            source = ./dashboard.sh;
        };

        home.file.".config/eww/variables.sh" = {
            executable = true;
            source = ./variables.sh;
        };
    };
}
