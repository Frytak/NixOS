{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.system.users;
in

{
    imports = [
        ./frytak
    ];

    options.modules.system.users = {
        enableAll = lib.mkEnableOption "all users";
    };

    config = lib.mkIf moduleConfig.enableAll {
        modules.system.users.frytak.enable = true;
    };
}
