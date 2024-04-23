{ config, lib, pkgs, ... }:

{
    options.modules.system.gcc = {
        enable = lib.mkEnableOption "GNU Compiler Collection";
    };
    
    config = lib.mkIf config.modules.system.gcc.enable {
        environment.systemPackages = [ pkgs.libgcc ];
    };
}
