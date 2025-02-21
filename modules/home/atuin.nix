{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.home.atuin;
in

{
    options.modules.home.atuin = {
        enable = lib.mkEnableOption "atuin";

        disableDefaultKeybinds = lib.mkOption {
            description = "Disable default Atuin key bindings";
            type = lib.types.bool;
            default = false;
        };
    };
    
    config = lib.mkIf moduleConfig.enable {
        programs.atuin = {
            enable = true;
            flags = [] ++ (if (moduleConfig.disableDefaultKeybinds) then ([ "--disable-up-arrow" "--disable-ctrl-r" ]) else ([]));
        };
    };
}
