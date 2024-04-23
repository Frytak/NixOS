{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.shells.fish;
in

{
    options.modules.shells.fish = {
        enable = lib.mkEnableOption "fish shell";
    };
    
    config = lib.mkIf moduleConfig.enable {
        programs.fish = {
            enable = true;
	};
    };
}
