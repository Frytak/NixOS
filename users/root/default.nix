{ lib, inputs, ... }:

let
    USER = "root";
    HOME = "/" + USER;
in

{
    home = {
        stateVersion = "25.05";
        username = USER;
        homeDirectory = HOME;
    };

    modules.home = {
        frytak-nixvim.enable = true;
        fish.enable = true;
        git.enable = true;
        hyfetch.enable = true;
    };
}
