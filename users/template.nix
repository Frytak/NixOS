{ ... }:

let
    USER = "USER";
    HOME = "/home/${USER}";
in

{
    imports = [ ../../modules/home ];

    home = {
        stateVersion = "23.11";
        username = USER;
        homeDirectory = HOME;
    };

    modules = {
    };
}
