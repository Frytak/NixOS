{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.nvim;
in

{
    options.modules.nvim = {
        enable = lib.mkEnableOption "Neovim";
    };
    
    config = lib.mkIf moduleConfig.enable {
        home.packages = [ pkgs.neovim ];
        #environment.systemPackages = [ pkgs.neovim ];
    };
}
