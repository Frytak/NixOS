{ config, lib, ... }:

let
    moduleConfig = config.modules.system.sound;
in

{
    options.modules.system.sound = {
        enable = lib.mkEnableOption "Default sound";
    };

    config = lib.mkIf moduleConfig.enable {
        # Enable sound.
        security.rtkit.enable = true;
        services.pipewire = {
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            jack.enable = true;
            pulse.enable = true;
        }; 
    };
}
