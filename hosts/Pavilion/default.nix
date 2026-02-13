{ config, inputs, pkgs, systemName, lib, ... }@args:

{
    imports = [
        ./hardware-configuration.nix
        ../../modules/system
    ];

    system.stateVersion = "23.11";

    # Enable default system configuration
    modules.system = {
        boot_loader.enable = true;
        home-manager.enable = true;
        users.enable = true;
        locales.enable = true;
        fonts.enable = true;
        sound.enable = true;
        network-manager.enable = true;
        bluetooth.enable = true;
        printers.enable = true;
        hyprland.enable = true;
    };

    environment.variables = {
        NIXOS_OZONE_WL = 1;
        GBM_BACKEND = "nvidia-drm";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        WLR_NO_HARDWARE_CURSORS = "1";
        LIBVA_DRIVER_NAME = "nvidia";
        NVD_BACKEND = "direct";
        MOZ_DISABLE_RDD_SANDBOX = "1";
    };

    # Graphic drivers
    nixpkgs.config.cudaSupport = true;
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware = {
        graphics = {
            enable = true;
            enable32Bit = true;
            extraPackages = with pkgs; [ nvidia-vaapi-driver libvdpau-va-gl ];
        };

        nvidia = {
            package = config.boot.kernelPackages.nvidiaPackages.production;
            modesetting.enable = true;
            powerManagement.enable = false;
            powerManagement.finegrained = false;
            open = true;
            nvidiaSettings = true;

            prime = {
                offload.enable = true;
                offload.enableOffloadCmd = true;

                nvidiaBusId = "PCI:1:0:0";
                amdgpuBusId = "PCI:5:0:0";
            };
        };
    };

    environment.systemPackages = with pkgs; [ ];



    virtualisation.docker.enable = true;
    services = {
        input-remapper.enable = true;
        postgresql.enable = true;
        logmein-hamachi.enable = true;
        # TODO: make system module
        openssh = {
            enable = true;
            settings = {
                PasswordAuthentication = false;
                PermitRootLogin = "no";
                PubkeyAuthentication = true;
            };
        };
        avahi = {
            enable = true;
            nssmdns4 = true;
            openFirewall = true;
        };
    };
}
