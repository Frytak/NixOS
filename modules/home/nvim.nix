{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.home.nvim;
in

{
    options.modules.home.nvim = {
        enable = lib.mkEnableOption "Neovim";

        configSource = lib.mkOption {
            description = "Where should the nvim configuration be sourced from?";
            type = lib.types.enum [ "github" "local" ];
            default = "github";
            example = "local";
        };

        configLocalPath = lib.mkOption {
            description = "Path to the local config. (For this to take action `configSource` must be set to `local`)";
            type = lib.types.path;
            default = /dev/null;
            example = "~/ProgrammingProjects/NvimConfig/";
        };
    };
    
    config = lib.mkIf moduleConfig.enable {
        assertions = [
            {
                assertion = (moduleConfig.configSource != "local") || (moduleConfig.configLocalPath != /dev/null);
                message = "Local `nvim.configSource` requires `nvim.configLocalPath` to be set.";
            }
        ];

        home.packages = with pkgs; [
            neovim
            texlab
            latexrun
            texliveFull
        ];
         
        home.file.".config/nvim/".source =
        (if (moduleConfig.configSource == "github") then
            fetchGit {
                url = "https://github.com/Frytak/NvimConfig";
                rev = "14d37ad689455baa9c573be14569449b1c471deb";
            }
        else if (moduleConfig.configSource == "local") then
            moduleConfig.configLocalPath
        else
            lib.error "Unreachable code."
        );
    };
}
