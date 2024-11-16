{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.system.users;
in

{
    options.modules.system.users = {
        enable = lib.mkEnableOption "Default users";
    };

    config = lib.mkIf moduleConfig.enable {
        programs.fish.enable = true;
        users.users.frytak = {
            isNormalUser = true;
            shell = pkgs.fish;
            extraGroups = [ "nixos_manager" "wheel" "networkmanager" "docker" "jackaudio" ];
        };
    };
}
