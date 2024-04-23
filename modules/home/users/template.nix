{ config, ... }:

{
    imports = [ ../../default.nix ];
    modules = {
    };

    home = {
        stateVersion = "23.11";
        username = "USER";
        homeDirectory = "/home/USER";
    };
}
