{ lib, pkgs, systemName, inputs, ... }:

let
    USER = "frytak";
    HOME = "/home/" + USER;
in

{
    imports = [ ../../modules/home ];

    home = {
        stateVersion = "24.05";
        username = "frytak";
        homeDirectory = "/home/frytak";
    };

    home.packages = with pkgs; [
        unar
        zip

        cliphist
        #cachix

        fzf
        sshfs
        wineWowPackages.waylandFull

        btop
        vesktop
        qbittorrent
        telegram-desktop
        figma-linux
        logmein-hamachi
        krita
        obs-studio
        clapper
        coppwr
        blender
        prismlauncher
    ];

    services.cachix-agent = {
        enable = true;
        credentialsFile = "${HOME}/.cachix.token";
        profile = USER;
        name = "${USER}-cachix-agent";
    };

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
        #swww.enable = true;
        displayManagers.wayland.hyprland = {
            enable = true;
            swaync.enable = true;
            grimblast.enable = true;
            #exec-once = [
            #    # TODO: https://www.reddit.com/r/hyprland/comments/16r7ad9/comment/kcpkj3w/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
            #    "sleep 5 && swww img ${HOME}/Downloads/nature_overtake.png"
            #];
        };

        games = {
            enable = true;
            steam.enable = true;
        };

        ssh = {
            enable = true;
            extraConfig = ''Host frytak
  HostName github.com
  IdentityFile ~/.ssh/id_rsa
  User git

host hetzner vps-hetzner
    hostname 5.75.188.219
    user frytak
    identityFile ~/.ssh/id_rsa
    IdentitiesOnly yes
    VisualHostKey yes

            '';
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
