{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.home.ollama;
in

{
    options.modules.home.ollama = {
        enable = lib.mkEnableOption "OLlama";
    };
    
    config = lib.mkIf moduleConfig.enable {
        home.packages = [ pkgs.ollama ];
        #services.ollama.enable = true;
    };
}
