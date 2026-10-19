{ config, lib, ... }:

let
    moduleConfig = config.modules.system.openssh;
in

{
    options.modules.system.openssh = {
        enable = lib.mkEnableOption "OpenSSH server";

        permitTunnel = lib.mkOption {
            description = "Whether to allow tunneled (VPN) connections.";
            type = lib.types.bool;
            default = false;
        };
    };

    config = lib.mkIf moduleConfig.enable {
        services.openssh = {
            enable = true;
            settings = {
                PasswordAuthentication = false;
                PermitRootLogin = "no";
                PubkeyAuthentication = true;
            }
            // lib.optionalAttrs moduleConfig.permitTunnel {
                PermitTunnel = "yes";
            };
        };
    };
}
