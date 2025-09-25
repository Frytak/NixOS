{ config, lib, pkgs, unstablePkgs, ... }:

let
    moduleConfig = config.modules.home.quickshell;
in

{
    options.modules.home.quickshell = {
        enable = lib.mkEnableOption "quickshell";
    };

    config = lib.mkIf moduleConfig.enable {
        home.packages = [
            unstablePkgs.quickshell
        ];
    };
}
