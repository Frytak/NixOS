{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.home.fish;
in

{
    options.modules.home.fish = {
        enable = lib.mkEnableOption "fish shell";
    };
    
    config = lib.mkIf moduleConfig.enable {
        home.packages = [ pkgs.fishPlugins.bass ];
        programs.fish = {
            enable = true;

            functions = {
                fish_greeting.body = ''
                    set bold $(${pkgs.ncurses}/bin/tput bold)
                    set normal $(${pkgs.ncurses}/bin/tput sgr0)
                    echo -n $bold
                    ${pkgs.fortune-kind}/bin/fortune -a all
                    echo -n $normal
                '';
            };
        };
    };
}
