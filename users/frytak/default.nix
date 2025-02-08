{ lib, pkgs, systemName, inputs, ... }:

let
    USER = "frytak";
    HOME = "/home/" + USER;
in

{
    imports = [
        ../../modules/home
        inputs.tbsm.homeManagerModules.tbsm
    ];

    tbsm = {
        enable = true;
        config = ''
            XserverArg="-quiet -nolisten tcp"
            verboseLevel=1
            theme=""
        '';
        sessions = [
            {
                Name = "Hyprland";
                Comment = "Start the Hyprland Wayland Compositor";
                Exec = "${pkgs.hyprland}/bin/Hyprland";
                Type = "Application";
                DesktopNames = "Hyprland";
                Keywords = "wayland;compositor;hyprland;";
            }
        ];
    };

    programs.fish.shellInit = ''
        # Launch TBSM on specific TTYs after login
        if [ -z "$DISPLAY" ];
            set allowed_ttys "all"
            set current_tty $(tty)

            # If "all" is in the allowed_ttys list, launch on any TTY
            if echo "$allowed_ttys" | ${pkgs.gnugrep}/bin/grep -q "all"
                exec ${inputs.tbsm.packages.${pkgs.system}.tbsm}/bin/tbsm </dev/tty >/dev/tty 2>&1
            # If the current TTY is in the allowed list
            else if echo "$allowed_ttys" | ${pkgs.gnugrep}/bin/grep -q "$current_tty"
                exec ${inputs.tbsm.packages.${pkgs.system}.tbsm}/bin/tbsm </dev/tty >/dev/tty 2>&1
            end
        end
    '';

    home = {
        stateVersion = "24.05";
        username = USER;
        homeDirectory = HOME;
        sessionVariables = {
            EDITOR = "nvim";
            QT_QPA_PLATFORM = "xcb";
        };
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
        nautilus
        android-studio
        lmstudio
        atuin
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

        theme = {
            package = pkgs.tokyonight-gtk-theme;
            name = "Tokyonight-Dark";
        };

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
        foot.enable = true;
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
        ranger.enable = true;
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
