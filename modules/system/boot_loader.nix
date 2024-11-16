{ config, lib, ... }:

let
    moduleConfig = config.modules.system.boot_loader;
in

{
    options.modules.system.boot_loader = {
        enable = lib.mkEnableOption "Default boot loader";
    };

    config = lib.mkIf moduleConfig.enable {
        # Use the systemd-boot EFI boot loader.
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
        boot.supportedFilesystems = [ "ntfs" ];
    };
}
