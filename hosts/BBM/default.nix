{ config, inputs, pkgs, systemName, lib, revursiveMerge, ... }@args:

{
    imports = [
        inputs.home-manager.nixosModules.default
        ./hardware-configuration.nix
    ];

    system.stateVersion = "24.05";
    networking.hostName = systemName;

    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
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

    virtualisation.docker.enable = true;

    networking.networkmanager.enable = true;

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
    #console = {
    #    font = "Lat2-Terminus16";
    #    keyMap = "pl";
    #};

    # Graphic drivers
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware = {
        opengl = {
            enable = true;
            #driSupport = true;
            driSupport32Bit = true;
        };

        nvidia = {
            package = config.boot.kernelPackages.nvidiaPackages.stable;
            modesetting.enable = true;
            powerManagement.enable = false;
            powerManagement.finegrained = false;
            open = false;
            nvidiaSettings = true;

            #prime = {
            #    nvidiaBusId = "PCI:1:0:0";
            #    amdgpuBusId = "PCI:5:0:0";

            #    #sync.enable = true;

            #    offload = {
            #        enable = true;
            #        enableOffloadCmd = true;
            #    };
            #};
        };
    };


    # Enable sound.
    sound.enable = true;
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

    environment.systemPackages = with pkgs; [
    vim
    neovim
    git

    # Temporary
    cliphist
    wl-clipboard

    lshw
    #(pkgs.wrapFirefox (pkgs.firefox-unwrapped.override { pipewireSupport = true;}) {})
    ];

    # Enable the OpenSSH daemon.
    services.openssh.enable = true;
}
