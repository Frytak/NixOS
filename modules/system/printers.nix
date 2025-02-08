{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.system.printers;
in

{
    options.modules.system.printers = {
        enable = lib.mkEnableOption "Printers";
    };

    config = lib.mkIf moduleConfig.enable {
        services.printing.enable = true;
        services.printing.drivers = with pkgs; [
            cnijfilter_4_00
        ];
    };
}
