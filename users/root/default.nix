{ lib, ... }:

let
    USER = "root";
    HOME = "/" + USER;
in

{
    imports = [ ../../modules/home ];

    home = {
        stateVersion = "23.11";
        username = USER;
        homeDirectory = HOME;
    };

    modules.home = {
        shells.fish.enable = true;
        editors.nvim.enable = true;
        git.enable = true;
        hyfetch = {
            enable = true;
            ascii = "bad_dragon";
        };
    };
}
