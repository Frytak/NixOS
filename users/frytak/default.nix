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
    home = {
        stateVersion = "25.05";
        username = USER;
        homeDirectory = HOME;
        sessionVariables = {
            EDITOR = "nvim";
            QT_QPA_PLATFORM = "wayland";
            GTK_USE_PORTAL = "1";
        };
    };

    programs.vicinae = {
        enable = true;
        systemd = {
            enable = true;
            autoStart = true;
        };

        settings = {
            font = {
                family = "JetBrains Mono";
            };
            window = {
                opacity = 0.9;
            };
            keybinds = {
                "action.copy" = "control+C";
            };
        };

        extensions = with inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}; [
            bluetooth
            nix
            firefox
            hypr-keybinds
            wifi-commander
        ];
    };

    nixpkgs.overlays = [
        (final: prev: {
            btop = prev.btop.override { cudaSupport = true; };

            clapper = prev.clapper.override {
                buildInputs = prev.clapper.buildInputs ++ [
                    prev.gst_all_1.gst-plugins-bad
                    prev.gst_all_1.gst-plugins-ugly
                    prev.gst_all_1.gst-libav
                ];
            };
        })
    ];

    home.packages = with pkgs; [
        unar
        zip
        rsync

        cliphist

        fzf
        sshfs
        wineWow64Packages.waylandFull
        btop
        brightnessctl

        krita
        pinta
        kdePackages.kolourpaint

        vesktop
        discord
        qbittorrent
        mgba
        telegram-desktop
        obs-studio
        v4l-utils
        coppwr
        prismlauncher
        nautilus
        android-studio
        inkscape
        linux-wifi-hotspot
        zathura # PDF viewer (also needed for nvim LaTeX)
        everest-mons
        ripgrep
        teams-for-linux
        tigervnc
        zulu25 # Java 25
        clapper
    ];

    modules.home = {
        frytak-nixvim.enable = true;
        git.enable = true;
        fish.enable = true;
        starship.enable = true;
        alacritty.enable = true;
        firefox.enable = true;
        ranger.enable = true;

        #frytak-quickshell.enable = true;

        noctalia = {
            enable = true;
            wallpaper = import ./current-wallpaper.nix;
        };

        atuin = {
            enable = true;
            disableDefaultKeybinds = true;
        };

        rmpc = {
            enable = true;
            enableMpd = true;
            enableMpdMpris = true;
        };

        # Wallpaper
        #hyprpaper = {
        #    enable = true;
        #    wallpaper = import ./current-wallpaper.nix;
        #};

        # System information tool
        hyfetch = {
            enable = true;
            ascii = "bad_dragon";
        };

        displayManagers.wayland.hyprland = {
            enable = true;
            swaync.enable = true;
            grimblast.enable = true;

            extraConfig = ''
                --hl.on("hyprland.start", function()
                --    hl.exec_cmd("[workspace special:8 silent] uwsm app -- quickshell")
                --end)

                hl.bind(mod .. " + D", hl.dsp.exec_cmd("uwsm app -- vicinae toggle"))
            '';
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

    programs.fish.shellInit = ''
        # Bind Atuin global search to SHIFT+UP_ARROW
        bind shift-up "${pkgs.atuin}/bin/atuin search -i"

        # Bind Atuin local search to CTRL+UP_ARROW
        bind ctrl-up "${pkgs.atuin}/bin/atuin search --filter-mode directory -i"

        # Bind Atuin session search to CTRL+SHIFT+UP_ARROW
        bind ctrl-shift-up "${pkgs.atuin}/bin/atuin search --filter-mode session -i"

        # Auto-start Hyprland on TTY1
        if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ];
            exec uwsm start hyprland-uwsm.desktop
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
        gtk4.theme = null;

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
            unstable.lmstudio
            #unstable.ollama
            unstable.ollama-cuda
        ];
    }
else if (systemName == "Pavilion") then
    {
    }
else
    lib.warn "User `${USER}` has no configuration for system `${systemName}`."
    { }
)]
