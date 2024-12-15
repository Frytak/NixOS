{ lib, pkgs, systemName, inputs, ... }:

let
    USER = "Timothy";
    HOME = "/home/" + USER;
in

{
    imports = [ ../../modules/home ];

    home = {
        stateVersion = "24.05";
        username = "Timothy";
        homeDirectory = "/home/Timothy";
    };

    home.packages = with pkgs; [
        unar
        zip

        cliphist
        #cachix

        sshfs
        wineWowPackages.waylandFull

        btop
        telegram-desktop
        clapper
        prismlauncher
    ];

    # Wallpaper
    services.hyprpaper = {
        enable = true;
        settings = {
            preload = [ "/etc/nixos/wallpapers/old_car.png" ];
            wallpaper = [ ", /etc/nixos/wallpapers/old_car.png" ];
        };
    };

    # Themes
    home.pointerCursor = {
        gtk.enable = true;
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 11;
    };

    gtk = {
        enable = true;

        #theme = {
        #    package = pkgs.yaru-remix-theme;
        #    name = "Yaru-remix-dark";
        #};

        #theme = {
        #    package = pkgs.flat-remix-gtk;
        #    name = "Flat-Remix-GTK-Grey-Darkest";
        #};

        #iconTheme = {
        #    package = pkgs.adwaita-icon-theme;
        #    name = "Adwaita";
        #};
    };

    modules.home = lib.attrsets.recursiveUpdate
    {
        git.enable = true;
        fish.enable = true;
        alacritty.enable = true;
        nvim = {
            enable = true;
            configSource = "local";
            configLocalPath = "${HOME}/ProgrammingProjects/NvimConfig";
        };
        firefox.enable = true;
        hyfetch = {
            enable = true;
            ascii = "bad_dragon";
        };
        tofi = {
            enable = true;
            theme = "frytak";
        };
        waybar.enable = true;
        displayManagers.wayland.hyprland = {
            enable = true;
            swaync.enable = true;
            grimblast.enable = true;
        };

        games = {
            enable = true;
            steam.enable = true;
        };

        ssh = {
            enable = true;
            ssh-agent.enable = true;
        };
    }

    # System specific user configuration.
    (if (systemName == "BBM") then
        {
        }
    else if (systemName == "Pavilion") then
        {
        }
    else
        lib.warn "User `${USER}` has no configuration for system `${systemName}`."
        { }
    );
}
