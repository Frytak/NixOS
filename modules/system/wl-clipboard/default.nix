{ config, lib, pkgs, ... }:

{
    options.modules.system.wl-clipboard = {
        enable = lib.mkEnableOption "wl-clipboard";
    };
    
    config = lib.mkIf config.modules.system.wl-clipboard.enable {
        environment.systemPackages = [ pkgs.wl-clipboard ];
    };
}
