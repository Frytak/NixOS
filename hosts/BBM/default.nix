{ config, inputs, pkgs, systemName, lib, ... }@args:

{
    imports = [
        ./hardware-configuration.nix
        ../../modules/system
    ];

    system.stateVersion = "24.05";

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

    boot.tmp.useTmpfs = true;

    services.flatpak.enable = true;

    security.polkit.enable = true;

    systemd.services."getty@tty1".environment = {
        XDG_SESSION_TYPE = "x11";
    };

    # Graphic drivers
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware = {
        graphics = {
            enable = true;
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
            };
        };
    };

    environment.systemPackages = with pkgs; [ ];



    programs.adb.enable = true;
    hardware.sane.enable = true; # enables support for SANE scanners
    virtualisation.docker.enable = true;

    services = {
        input-remapper.enable = true;
        postgresql.enable = true;
        logmein-hamachi.enable = true;
        openssh.enable = true;

        ollama = {
            enable = true;
            acceleration = "cuda";
        };

        avahi = {
            enable = true;
            nssmdns4 = true;
            openFirewall = true;
        };
    };
}
