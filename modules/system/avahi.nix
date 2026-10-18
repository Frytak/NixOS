{ config, lib, ... }:

let
    moduleConfig = config.modules.system.avahi;
in

{
    options.modules.system.avahi = {
        enable = lib.mkEnableOption "Avahi (mDNS/DNS-SD)";
    };

    config = lib.mkIf moduleConfig.enable {
        services.avahi = {
            enable = true;
            nssmdns4 = true;
            openFirewall = true;
        };
    };
}
