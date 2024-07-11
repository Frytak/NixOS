{ lib, ... }:

let
    USER = "root";
    HOME = "/" + USER;
in

{
    imports = [ ../../modules/home ];

    home = {
        stateVersion = "24.05";
        username = USER;
        homeDirectory = HOME;
    };

    modules.home = {
        shells.fish.enable = true;
        editors.nvim = {
            enable = true;
            configSource = "local";
            configLocalPath = "/home/frytak/ProgrammingProjects/NvimConfig";
        };
        git.enable = true;
        hyfetch = {
            enable = true;
            ascii = "bad_dragon";
        };
    };
}
