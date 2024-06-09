{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.home.games.prismlauncher;
in

{
    options.modules.home.games.prismlauncher = {
        enable = lib.mkEnableOption "PrismLauncher";
    };
    
    config = lib.mkIf moduleConfig.enable {
        home.packages = [ pkgs.prismlauncher ];
    };
}
