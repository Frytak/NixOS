{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.home.users;
in

{
    imports = [
        ./root
        ./frytak
    ];

    options.modules.home.users = {
        enableAll = lib.mkEnableOption "all users";
    };

    config = lib.mkIf moduleConfig.enableAll {
        modules.home.users = {
            root.enable = true;
            frytak.enable = true;
        };
    };
}
