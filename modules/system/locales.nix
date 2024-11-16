{ config, lib, ... }:

let
    moduleConfig = config.modules.system.locales;
in

{
    options.modules.system.locales = {
        enable = lib.mkEnableOption "Default locales";
    };

    config = lib.mkIf moduleConfig.enable {
        # Set up locales.
        time.timeZone = "Europe/Warsaw";
        i18n = {
            defaultLocale = "en_US.UTF-8";
            extraLocaleSettings = {
                LC_TIME = "en_GB.UTF-8";
                LC_MEASUREMENT = "en_GB.UTF-8";
                LC_MONETARY = "pl_PL.UTF-8";
                LC_NUMERIC = "pl_PL.UTF-8";
                LC_TELEPHONE = "pl_PL.UTF-8";
            };
        };
    };
}
