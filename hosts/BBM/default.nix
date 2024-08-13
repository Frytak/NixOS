{ config, inputs, pkgs, systemName, lib, ... }@args:

{
    imports = [
        inputs.home-manager.nixosModules.home-manager
        ./hardware-configuration.nix
    ];

    system.stateVersion = "24.05";
    networking.hostName = systemName;

    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.supportedFilesystems = [ "ntfs" ];

    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    #environment.variables.HYPRCURSOR_THEME = "McMojave";
    environment.systemPackages = with pkgs; [
        #inputs.mcmojave-hyprcursor.packages.${pkgs.stdenv.hostPlatform.system}.default
        vim
        neovim
        git

        xwayland
        unar
        zip
        obs-studio
        clapper

        # Temporary
        cliphist
        wl-clipboard
        lshw
    ];

    # Enable the OpenSSH daemon.
    services.openssh.enable = true;
    services.input-remapper.enable = true;

    xdg.portal = {
        enable = true;
        config.common.default = "*";
        extraPortals = with pkgs; [
            xdg-desktop-portal-hyprland
        ];
    };

    fonts = {
        packages = with pkgs; [
            (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
        ];

        fontconfig.defaultFonts = {
            monospace = [ "JetBrainsMono Nerd Font" ];
        };
    };

    # Set up locales.
    time.timeZone = "Europe/Warsaw";
    i18n = {
        defaultLocale = "en_US.UTF-8";
        extraLocaleSettings = {
            LC_TIME = "en_GB.UTF-8";
            LC_MEASUREMENT = "en_GB.UTF-8";
            LC_MONETARY = "pl_PL.UTF-8";
            LC_NUMERIC = "pl_PL.UTF-8";
            LC_TELEPHONE = "pl_PL.UTF-8";
        };
    };

    # Graphic drivers
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware = {
        graphics = {
            enable = true;
            #driSupport = true;
            enable32Bit = true;
        };

        nvidia = {
            package = config.boot.kernelPackages.nvidiaPackages.production;
            modesetting.enable = true;
            powerManagement.enable = false;
            powerManagement.finegrained = false;
            open = false;
            nvidiaSettings = true;

            prime = {
                nvidiaBusId = "PCI:1:0:0";
                intelBusId = "PCI:0:2:0";

                sync.enable = true;

                #offload = {
                #    enable = true;
                #    enableOffloadCmd = true;
                #};
            };
        };
    };


    # Enable sound.
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
    };



    users.users.frytak = {
        isNormalUser = true;
        extraGroups = [ "nixos_manager" "wheel" "networkmanager" "docker" ];
    };

    home-manager = {
        useUserPackages = true;
        useGlobalPkgs = true;

        extraSpecialArgs = {
            inherit inputs;
            systemName = systemName;
        };

        users = let
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
            user = user: { ${user} = (recursiveMerge [(import ./home.nix args) (import ../../users/${user} args)]); };
        in (user "root")
        // (user "frytak");
    };



    virtualisation.docker.enable = true;
    networking.networkmanager.enable = true;

    nix.settings.trusted-public-keys = [
        crane.cachix.org-1:8Scfpmn9w+hGdXH/Q9tTLiYAE/2dnJYRJP7kl80GuRk=
        nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= 
        kairos.cachix.org-1:1EqnyWXEbd4Dn1jCbiWOF1NLOc/bELx+wuqk0ZpbeqQ=
    ];

    nix.settings.trusted-substituters = [
        https://crane.cachix.org
        https://nix-community.cachix.org
        https://kairos.cachix.org
    ];
}
