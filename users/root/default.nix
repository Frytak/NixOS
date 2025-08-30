{ lib, inputs, ... }:

let
    USER = "root";
    HOME = "/" + USER;
in

{
    imports = [
        ../../modules/home
        inputs.nixvim.homeManagerModules.nixvim
    ];

    home = {
        stateVersion = "25.05";
        username = USER;
        homeDirectory = HOME;
    };

    modules.home = {
        nvim.enable = true;
        fish.enable = true;
        git.enable = true;
        hyfetch.enable = true;
    };
}
