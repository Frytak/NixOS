{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.home.tofi;
in

{
    options.modules.home.tofi = {
        enable = lib.mkEnableOption "Tofi";

        theme = lib.mkOption {
            description = "A predefined config.";
            type = lib.types.enum [ "default" "frytak" ];
            default = "default";
        };

        extraConfig = lib.mkOption {
            description = "Additional config for Tofi.";
            type = lib.types.lines;
            default = "";
        };
    };
    
    config = lib.mkIf moduleConfig.enable {
        home.packages = with pkgs; [ tofi ];

        home.file.".config/tofi/config".text = (if (moduleConfig.theme == "default") then
            (builtins.readFile ./config)
        else if (moduleConfig.theme == "frytak") then
            (builtins.readFile ./frytak)
        else
            lib.error "Unreachable code."
        )
        + moduleConfig.extraConfig;
    };
}
