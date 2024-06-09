{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.home.qbittorrent;
in

{
    options.modules.home.qbittorrent = {
        enable = lib.mkEnableOption "QBitTorrent";
    };
    
    config = lib.mkIf moduleConfig.enable {
        home.packages = [ pkgs.qbittorrent ];
    };
}
