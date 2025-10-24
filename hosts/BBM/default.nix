{ config, inputs, pkgs, systemName, lib, ... }@args:

{
    imports = [
        ./hardware-configuration.nix
        ../../modules/system
    ];

    system.stateVersion = "25.05";

    boot.kernelModules = [ "v4l2loopback" ];
    boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];

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

    programs.nix-ld.enable = true;
    programs.nix-ld.libraries = with pkgs; [
    ];

    boot.tmp.useTmpfs = true;

    services.flatpak.enable = true;

    security.polkit.enable = true;

    systemd.services."getty@tty1".environment = {
        XDG_SESSION_TYPE = "x11";
    };

    # Wake on WLAN
    systemd.services.wowlan = {
        description = "Enable Wake on WLAN";
        after = [ "network.target" "NetworkManager.service" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = "${pkgs.iw}/bin/iw phy phy0 wowlan enable magic-packet";
        };
    };

    # Graphic drivers
    nixpkgs.config.cudaSupport = true;
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware = {
        uinput.enable = true;
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

    environment.systemPackages = with pkgs; [ runc nvidia-docker nvidia-container-toolkit ];



    programs.adb.enable = true;
    hardware.sane.enable = true; # enables support for SANE scanners

    virtualisation.docker.enable = true;
    virtualisation.docker.daemon.settings = {
        runtimes = {
            nvidia = {
                path = "/nix/store/01a3h4vvbg4c9y9xm140ldm3hjfd99py-nvidia-container-toolkit-1.17.6-tools/bin/nvidia-container-runtime";
                runtimeArgs = [];
            };
        };
    };
    #virtualisation.docker.enableNvidia = true;
    virtualisation.docker.extraOptions = "--default-runtime=nvidia";
    hardware.nvidia-container-toolkit.enable = true;
# Ensure Docker daemon configuration
  environment.etc."docker/daemon.json".text = ''
    {
      "default-runtime": "nvidia",
      "runtimes": {
        "nvidia": {
          "path": "/nix/store/01a3h4vvbg4c9y9xm140ldm3hjfd99py-nvidia-container-toolkit-1.17.6-tools/bin/nvidia-container-runtime",
          "runtimeArgs": []
        }
      }
    }
  '';

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
