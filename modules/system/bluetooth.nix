{ config, lib, ... }:

let
    moduleConfig = config.modules.system.bluetooth;
in

{
    options.modules.system.bluetooth = {
        enable = lib.mkEnableOption "Default bluetooth";
    };

    config = lib.mkIf moduleConfig.enable {
        hardware.bluetooth.enable = true;
        hardware.bluetooth.powerOnBoot = true;
        services.blueman.enable = true;
    };
}
