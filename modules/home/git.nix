{ config, lib, ... }:

{
    options.modules.home.git = {
        enable = lib.mkEnableOption "git";
    };
    
    config = lib.mkIf config.modules.home.git.enable {
        programs.git = {
            enable = true;
            userName = "Frytak";
            userEmail = "frytak2855@gmail.com";

            extraConfig = {
                init.defaultBranch = "main";
                safe.directory = [ "/etc/nixos" ];
            };
        };
    };
}
