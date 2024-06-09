{ lib, pkgs, systemName, ... }:

let
    USER = "frytak";
    HOME = "/home/" + USER;
in

{
    imports = [ ../../modules/home ];

    home = {
        stateVersion = "23.11";
        username = USER;
        homeDirectory = HOME;
    };

    home.packages = with pkgs; [
        cachix
        vesktop
        telegram-desktop
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
        obs.enable = true;
        hyfetch = {
            enable = true;
            ascii = "bad_dragon";
        };

        vesktop.enable = true;
        tofi = {
            enable = true;
            theme = "frytak";
        };
        swaync.enable = true;
        waybar = {
            enable = true;
            #systemd.enable = true;
        };
        swww.enable = true;
        displayManagers.wayland.hyprland = {
            enable = true;
            swaync.enable = true;
            grimblast.enable = true;
            exec-once = [
                # TODO: https://www.reddit.com/r/hyprland/comments/16r7ad9/comment/kcpkj3w/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
                "sleep 5 && swww img ${HOME}/Downloads/nature_overtake.png"
            ];
        };

        direnv.enable = true;

        #displayManagers.wayland.sway = {
        #    enable = true;
        #    grimshot.enable = true;
        #};
        #displayManagers.x11 = {
        #    enable = true;
        #    i3.enable = true;
        #};

        games = {
            enable = true;
            prismlauncher.enable = true;
        };

        wine.enable = true;
        qbittorrent.enable = true;
        ollama.enable = true;
        ssh = {
            enable = true;
            extraConfig = ''Host frytak
  HostName github.com
  IdentityFile ~/.ssh/id_rsa
  User git
            '';
            ssh-agent.enable = true;
        };
    }

    # System specific user configuration.
    (if (systemName == "BBM") then
        {
            displayManagers.wayland.sway.additionalConfig = ''
                output HDMI-A-1 bg ${HOME}/Downloads/nature_overtake.png fill #000000
                output HDMI-A-2 bg ${HOME}/Downloads/nature_overtake.png fill #000000
            '';
        }
    else
        lib.warn "User `${USER}` has no configuration for system `${systemName}`."
        { }
    );
}
