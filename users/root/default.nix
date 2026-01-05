{ lib, inputs, ... }:

let
    USER = "root";
    HOME = "/" + USER;
in

{
    imports = [
        ../../modules/home
        inputs.frytak-nixvim.homeModules.default
    ];

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
