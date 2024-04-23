{ config, lib, pkgs, ... }:

let
    moduleOptions = options.modules.MODULE;
    moduleConfig = config.modules.MODULE;
in

{
    # TODO
    moduleOptions = {
        enable = lib.mkEnableOption "MODULE"
    };
    
    config = lib.mkIf moduleConfig.enable {
        # Define a user account.
        users.users.USER = {
	    description = "...";
            isNormalUser = true;

            extraGroups = [ "wheel" "networkmanager" ];
        };
    };
}
