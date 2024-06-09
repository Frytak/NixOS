{ config, inputs, pkgs, ... }:

{
    imports = [
        #inputs.home-manager.nixosModules.default
        ./hardware-configuration.nix
    ];

    config = {
        system.stateVersion = "23.11";
        nix.settings.experimental-features = [ "nix-command" "flakes" ];
        nixpkgs.config.allowUnfree = true;	

        # Use the systemd-boot EFI boot loader.
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;

        # Set up hostname.
        networking = {
            hostName = "bbm";
            networkmanager.enable = true;
        };

        environment.systemPackages = with pkgs; [
            neovim
            firefox
            git
        ];

        services = {
            xserver = {
                enable = true;
                windowManager.i3.enable = true;
                displayManager.defaultSession = "none+i3";
                xkb.layout = "pl";
                videoDrivers = [ "modesetting" ];
            };
        };

        hardware.opengl = {
            enable = true;
            driSupport = true;
            driSupport32Bit = true;
            extraPackages = with pkgs; [
                intel-compute-runtime
                intel-media-driver
            ];
        };


        #security.rtkit.enable = true;
        #sound.enable = true;
        #services.pipewire = {
        #    enable = true;
        #    alsa.enable = true;
        #    alsa.support32Bit = true;
        #    pulse.enable = true;
        #};

        #hardware = {
        #    nvidia = {
        #    modesetting.enable = true;
        #    nvidiaSettings = true;
        #    package = config.boot.kernelPackages.nvidiaPackages.stable;
        #    opengl = {
        #        enable = true;
        #        driSupport = true;
        #        driSupport32Bit = true;
        #    };
        #};

        #home-manager = {
        #    useUserPackages = true;
        #    useGlobalPkgs = true;
        #    extraSpecialArgs = {
        #        inherit inputs;
        #    };
        #    users = {
        #        frytak = import ../../modules/home/users/frytak;
        #    };
        #};


        # Set up locales.
        #time.timeZone = "Europe/Warsaw";
        #i18n = {
        #    defaultLocale = "en_US.UTF-8";
        #    extraLocaleSettings = {
        #        LC_TIME = "en_GB.UTF-8";
        #        LC_MEASUREMENT = "en_GB.UTF-8";
        #        LC_MONETARY = "pl_PL.UTF-8";
        #        LC_NUMERIC = "pl_PL.UTF-8";
        #        LC_TELEPHONE = "pl_PL.UTF-8";
        #    };
        #};

        #console = {
        #    font = "Lat2-Terminus16";
        #    keyMap = "pl";
        #};

        #modules.system = {
        #    enable = true;
        #    boot.enable = true;
        #    fonts.enable = true;
        #    networking.enable = true;
        #    users.enableAll = true;
        #    #gcc.enable = true;
        #    "wl-clipboard".enable = true;
        #    swaybg.enable = true;
        #    #steam.enable = true;
        #    mgba.enable = true;
        #};
    };
}
