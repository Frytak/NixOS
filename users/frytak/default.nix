{ lib, pkgs, systemName, inputs, ... }:

let
    USER = "frytak";
    HOME = "/home/" + USER;

    # God bless them https://stackoverflow.com/a/54505212/16454500
    recursiveMerge = attrList:
    let f = attrPath:
        lib.zipAttrsWith (n: values:
            if lib.tail values == []
                then lib.head values
            else if lib.all lib.isList values
                then lib.unique (lib.concatLists values)
            else if lib.all lib.isAttrs values
                then f (attrPath ++ [n]) values
            else lib.last values
        );
    in f [] attrList;
in

recursiveMerge [{
    imports = [
        ../../modules/home
        inputs.tbsm.homeManagerModules.tbsm
        inputs.nixvim.homeManagerModules.nixvim
    ];

    home = {
        stateVersion = "25.05";
        username = USER;
        homeDirectory = HOME;
        sessionVariables = {
            EDITOR = "nvim";
            QT_QPA_PLATFORM = "wayland";
        };
    };

    home.packages = with pkgs; [
        unar
        zip
        rsync

        cliphist

        fzf
        sshfs
        wineWowPackages.waylandFull
        btop
        brightnessctl

        vesktop
        qbittorrent
        mgba
        telegram-desktop
        krita
        obs-studio
        v4l-utils
        clapper
        coppwr
        prismlauncher
        nautilus
        android-studio
        inkscape
        linux-wifi-hotspot
        zathura # PDF viewer (also needed for nvim LaTeX)
        everest-mons
        ripgrep
        vieb
        teams-for-linux
        wayvnc
    ];

    modules.home = {
        nvim.enable = true;
        git.enable = true;
        fish.enable = true;
        starship.enable = true;
        alacritty.enable = true;
        firefox.enable = true;
        ranger.enable = true;
        quickshell.enable = true;
        #waybar.enable = true;
        eww.enable = true;

        atuin = {
            enable = true;
            disableDefaultKeybinds = true;
        };

        rmpc = {
            enable = true;
            enableMpd = true;
        };

        # Wallpaper
        hyprpaper = {
            enable = true;
            wallpaper = "misty_forest_1920x1080.png";
        };

        # System information tool
        hyfetch = {
            enable = true;
            ascii = "bad_dragon";
        };

        # App launcher
        tofi = {
            enable = true;
            theme = "frytak";
        };

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
            extraConfig = ''
            Host frytak
                HostName github.com
                IdentityFile ~/.ssh/id_rsa
                User git
            '';
        };
    };

    ## Session manager
    #tbsm = {
    #    enable = true;
    #    config = ''
    #        XserverArg="-quiet -nolisten tcp"
    #        verboseLevel=1
    #        theme=""
    #    '';
    #    defaultSession = "Hyprland";
    #    sessions = [
    #        {
    #            Name = "Hyprland";
    #            Comment = "Start the Hyprland Wayland Compositor";
    #            Exec = "${pkgs.hyprland}/bin/Hyprland";
    #            Type = "Application";
    #            DesktopNames = "Hyprland";
    #            Keywords = "wayland;compositor;hyprland;";
    #        }
    #        {
    #            Name = "Hyprland (UWSM)";
    #            Comment = "Start the Hyprland Wayland Compositor";
    #            Exec = "${pkgs.uwsm}/bin/uwsm start hyprland.desktop";
    #            Type = "Application";
    #            DesktopNames = "Hyprland (UWSM)";
    #            Keywords = "wayland;compositor;hyprland;uwsm;";
    #        }
    #    ];
    #};

    # ; ${pkgs.ncurses}/bin/tput cuu1; ${pkgs.ncurses}/bin/tput cuf 2
    programs.fish.shellInit = ''
        # Bind Atuin global search to SHIFT+UP_ARROW
        bind shift-up "${pkgs.atuin}/bin/atuin search -i"

        # Bind Atuin local search to CTRL+UP_ARROW
        bind ctrl-up "${pkgs.atuin}/bin/atuin search --filter-mode directory -i"

        # Bind Atuin session search to CTRL+SHIFT+UP_ARROW
        bind ctrl-shift-up "${pkgs.atuin}/bin/atuin search --filter-mode session -i"

        # Launch TBSM on specific TTYs after login
        if [ -z "$DISPLAY" ];
            set allowed_ttys "/dev/tty1"
            set current_tty $(tty)

            # If "all" is in the allowed_ttys list, launch on any TTY
            if echo "$allowed_ttys" | ${pkgs.gnugrep}/bin/grep -q "all"
                #exec ${pkgs.bashInteractiveFHS}/bin/bash ${inputs.tbsm.packages.${pkgs.system}.tbsm}/bin/tbsm </dev/tty >/dev/tty 2>&1
                exec ${pkgs.bashInteractiveFHS}/bin/bash -c "${pkgs.uwsm}/bin/uwsm start default" 
            # If the current TTY is in the allowed list
            else if echo "$allowed_ttys" | ${pkgs.gnugrep}/bin/grep -q "$current_tty"
                #exec ${pkgs.bashInteractiveFHS}/bin/bash ${inputs.tbsm.packages.${pkgs.system}.tbsm}/bin/tbsm </dev/tty >/dev/tty 2>&1
                exec ${pkgs.bashInteractiveFHS}/bin/bash -c "${pkgs.uwsm}/bin/uwsm start default" 
            end
        end
    '';

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

        iconTheme = {
            package = pkgs.adwaita-icon-theme;
            name = "Adwaita";
        };
    };

    programs = {
        eza = {
            enable = true;
            icons = "always";
            extraOptions = [ "--group-directories-first" ];
            git = true;
        };
    };
}

# System specific user configuration.
(if (systemName == "BBM") then
    {
        home.packages = with pkgs; [
            davinci-resolve
            figma-linux
            blender
        ];
    }
else if (systemName == "Pavilion") then
    {
    }
else
    lib.warn "User `${USER}` has no configuration for system `${systemName}`."
    { }
)]
