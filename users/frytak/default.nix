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
    ];

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
        inkscape
        linux-wifi-hotspot
    ];

    modules.home = {
        git.enable = true;
        fish.enable = true;
        foot.enable = true;
        firefox.enable = true;
        ranger.enable = true;
        waybar.enable = true;

        # Wallpaper
        hyprpaper = {
            enable = true;
            wallpaper = "skeleton_army_1920x1080.png";
        };

        nvim = {
            enable = true;
            configSource = "local";
            configLocalPath = "${HOME}/ProgrammingProjects/NvimConfig";
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

    # Session manager
    tbsm = {
        enable = true;
        config = ''
            XserverArg="-quiet -nolisten tcp"
            verboseLevel=1
            theme=""
        '';
        defaultSession = "Hyprland";
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

    # Launch TBSM on specific TTYs after login
    programs.fish.shellInit = ''
        # Launch TBSM on specific TTYs after login
        if [ -z "$DISPLAY" ];
            set allowed_ttys "all"
            set current_tty $(tty)

            # If "all" is in the allowed_ttys list, launch on any TTY
            if echo "$allowed_ttys" | ${pkgs.gnugrep}/bin/grep -q "all"
                exec ${pkgs.bashInteractiveFHS}/bin/bash ${inputs.tbsm.packages.${pkgs.system}.tbsm}/bin/tbsm </dev/tty >/dev/tty 2>&1
            # If the current TTY is in the allowed list
            else if echo "$allowed_ttys" | ${pkgs.gnugrep}/bin/grep -q "$current_tty"
                exec ${pkgs.bashInteractiveFHS}/bin/bash ${inputs.tbsm.packages.${pkgs.system}.tbsm}/bin/tbsm </dev/tty >/dev/tty 2>&1
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
    };

    programs = {
        starship = {
            enable = true;
            settings = {
                format = lib.concatStrings [
                    "[█](fg:g1)[ $username  [](bg:g2 fg:g1)](bg:g1 fg:white bold)"
                    "[  $directory  [](bg:g3 fg:g2)](bg:g2 fg:white bold)"
                    "[  ($git_branch ) [](bg:g4 fg:g3)](bg:g3 fg:white bold)"
                    "[  ($rust )($c )($elixir )($golang )($gradle )($haskell )($java )($nodejs ) [](bg:g5 fg:g4)](bg:g4 fg:white bold)"
                    "[  ($cmd_duration ) [](fg:g5)](bg:g5 fg:white bold)\n"
                    "$character"
                ];

                cmd_duration = {
                    format = "$duration";
                    min_time = 0;
                    show_milliseconds = true;
                };

                username = {
                    format = "$user";
                    show_always = true;
                };

                directory = {
                    read_only = "";
                    format = "$path$read_only";
                };

                character = {
                    format = "$symbol";
                    success_symbol = "[ ](bold green)";
                    error_symbol = "[ ](bold red)";
                };

                git_branch = {
                    format = "$symbol$branch(:$remote_branch)";
                };

                rust = {
                    format = "$symbol($version)";
                };

                palette = "frytak";
                palettes = {
                    frytak = {
                        g1 = "#ad3232";
                        g2 = "#b53162";
                        g3 = "#ab448f";
                        g4 = "#8e5db2";
                        g5 = "#6373c5";
                    };
                };
            };
        };
        eza = {
            enable = true;
            icons = "always";
            extraOptions = [ "--group-directories-first" ];
            git = true;
        };
        atuin.enable = true;
    };
}

# System specific user configuration.
(if (systemName == "BBM") then
    {
        home.packages = with pkgs; [
            lmstudio
        ];
    }
else if (systemName == "Pavilion") then
    {
    }
else
    lib.warn "User `${USER}` has no configuration for system `${systemName}`."
    { }
)]
