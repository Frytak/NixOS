{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.system.users;
in

{
    options.modules.system.users = {
        enable = lib.mkEnableOption "Default users";
    };

    config = lib.mkIf moduleConfig.enable {
        users.users.frytak = {
            isNormalUser = true;
            shell = pkgs.bashInteractive;
            extraGroups = [ "nixos_manager" "wheel" "networkmanager" "docker" "jackaudio" "scanner" "lp" "adbusers" "audio" "video" "uinput"];
        };
    };
}
