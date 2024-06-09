{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.system.users.frytak;
in

{
    options.modules.system.users.frytak = {
        enable = lib.mkEnableOption "system user frytak";
    };
    
    config = lib.mkIf moduleConfig.enable {
        # Define a user account.
        users.users.frytak = {
            description = "Frytak";
            isNormalUser = true;

            extraGroups = [ "wheel" "networkmanager" "dialout" ];

            shell = pkgs.fish;
            ignoreShellProgramCheck = true;
        };
    };
}
