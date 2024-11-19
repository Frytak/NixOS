{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.home.ssh;
in

{
    options.modules.home.ssh = {
        enable = lib.mkEnableOption "SSH";

        extraConfig = lib.mkOption {
            description = "Extra configuration for SSH.";
            type = lib.types.lines;
            default = "";
        };

        ssh-agent.enable = lib.mkOption {
            description = "Whether to enable SSH key agent.";
            type = lib.types.bool;
            default = false;
        };
    };
    
    config = lib.mkIf moduleConfig.enable {
        programs.ssh = {
            enable = true;
            extraConfig = ''
            '' + moduleConfig.extraConfig;
        };

        services.ssh-agent.enable = moduleConfig.ssh-agent.enable;
    };
}
