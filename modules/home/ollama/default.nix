{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.home.ollama;
in

{
    options.modules.home.ollama = {
        enable = lib.mkEnableOption "Ollama";
    };
    
    config = lib.mkIf moduleConfig.enable {
        home.packages = [ pkgs.ollama ];
    };
}
