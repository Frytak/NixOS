{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.system.databases;
in

{
    options.modules.system.databases = {
        enable = lib.mkEnableOption "Databases (PostgreSQL)";

        mysql = {
            enable = lib.mkEnableOption "MariaDB (MySQL-compatible)";
        };
    };

    config = lib.mkIf moduleConfig.enable {
        services.postgresql.enable = true;

        services.mysql = lib.mkIf moduleConfig.mysql.enable {
            enable = true;
            package = pkgs.mariadb;
        };
    };
}
