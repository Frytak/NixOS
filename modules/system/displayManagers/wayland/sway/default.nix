{ config, lib, ...}:

{
    options.modules.system.displayManagers.wayland.sway = {
        enable = lib.mkEnableOption "lemurs";
    };
    
    config = lib.mkIf config.modules.system.displayManagers.wayland.sway.enable {
        systemd.user.services.swayLauncher = {
            wantedBy = [ "multi-user.target" ];
            script = ''
                exec sway
            '';
        };
    };
}
