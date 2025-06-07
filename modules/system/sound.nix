{ config, lib, pkgs, ... }:

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

        # For rtkit to work under users with the "audio" group
        #security.pam.loginLimits = [
        #    {
        #        domain = "@audio";
        #        type = "soft";
        #        item = "memlock";
        #        value = "unlimited";
        #    }
        #    {
        #        domain = "@audio";
        #        type = "hard";
        #        item = "memlock";
        #        value = "unlimited";
        #    }
        #    {
        #        domain = "@audio";
        #        type = "hard";
        #        item = "rtprio";
        #        value = "90";
        #    }
        #];
    };
}
