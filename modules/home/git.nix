{ config, lib, ... }:

{
    options.modules.home.git = {
        enable = lib.mkEnableOption "git";
    };
    
    config = lib.mkIf config.modules.home.git.enable {
        programs.git = {
            enable = true;
            settings = {
                user = {
                    name = "Frytak";
                    email = "frytak2855@gmail.com";
                };

                # Use ssh instead of https
                url."ssh://git@github.com" = {
                    insteadOf = "https://github.com/";
                };

                init.defaultBranch = "main";
                safe.directory = [ "/etc/nixos" ];
            };

            lfs.enable = true;
        };
    };
}
