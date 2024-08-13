{ lib, pkgs, systemName, inputs, ... }:

let
    USER = "frytak";
    HOME = "/home/" + USER;
in

{
    imports = [
        ../../modules/home
        ./themes
    ];

    home = {
        stateVersion = "24.05";
        username = USER;
        homeDirectory = HOME;
    };

    #home.sessionVariables.HYPRCURSOR_THEME = "McMojave";
    home.packages = [
        #inputs.mcmojave-hyprcursor.packages.${pkgs.stdenv.hostPlatform.system}.default
        pkgs.cachix
        pkgs.vesktop
        pkgs.qbittorrent
        pkgs.webcord-vencord
        pkgs.telegram-desktop
        pkgs.remmina
        pkgs.sshfs
        pkgs.fzf
    ];
    services.cachix-agent = {
        enable = true;
        credentialsFile = "${HOME}/.cachix.token";
        profile = USER;
        name = "${USER}-cachix-agent";
    };


    modules.home = lib.attrsets.recursiveUpdate
    {
        git.enable = true;
        editors.nvim = {
            enable = true;
            configSource = "local";
            configLocalPath = "${HOME}/ProgrammingProjects/NvimConfig";
        };
        browsers.firefox.enable = true;
        terminals.alacritty.enable = true;
        shells.fish.enable = true;
        #obs.enable = true;
        hyfetch = {
            enable = true;
            ascii = "bad_dragon";
        };

        #vesktop.enable = true;
        tofi = {
            enable = true;
            theme = "frytak";
        };
        swaync.enable = true;
        waybar = {
            enable = true;
            #systemd.enable = true;
        };
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

        direnv.enable = true;

        games = {
            enable = true;
            steam.enable = true;
            prismlauncher.enable = true;
        };

        wine.enable = true;
        #qbittorrent.enable = true;
        #ollama.enable = true;
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
            # TODO: Move to Pavilion configuration
            displayManagers.wayland.hyprland.config.settings = {
                monitor = [
                    "eDP-1, 1920x1080@60, 0x0, 1.2"
                ];

                workspace = [
                    "name:1, monitor:eDP-1, default:true"
                    "name:2, monitor:eDP-1"
                    "name:3, monitor:eDP-1"
                    "name:4, monitor:eDP-1"
                    "name:5, monitor:eDP-1"
                    "name:6, monitor:eDP-1"
                ];
            };
        }
    else
        lib.warn "User `${USER}` has no configuration for system `${systemName}`."
        { }
    );
}
