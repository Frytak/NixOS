{ config, options, lib, pkgs, ... }:

let
    moduleConfig = config.modules.system.boot;
in

{
    # TODO
    options.modules.system.boot = {
        enable = lib.mkEnableOption "system boot";
    };
    
    config = lib.mkIf moduleConfig.enable {
        # Use the systemd-boot EFI boot loader.
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
    };
}
