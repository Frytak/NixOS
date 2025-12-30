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

            # Default SSH config options (defaults were deprecated in 25.11, now they are set manually like so)
            enableDefaultConfig = false;
            matchBlocks."*" = {
                forwardAgent = false;
                addKeysToAgent = "no";
                compression = false;
                serverAliveInterval = 0;
                serverAliveCountMax = 3;
                hashKnownHosts = false;
                userKnownHostsFile = "~/.ssh/known_hosts";
                controlMaster = "no";
                controlPath = "~/.ssh/master-%r@%n:%p";
                controlPersist = "no";
            };
        };

        services.ssh-agent.enable = moduleConfig.ssh-agent.enable;
    };
}
