{ config, inputs, pkgs, systemName, lib, ... }@args:

{
    imports = [
        ./hardware-configuration.nix
        ../../modules/system
    ];

    system.stateVersion = "25.05";

    boot.kernelModules = [ "v4l2loopback" ];
    boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];

    # For OBS virtual camera
    boot.extraModprobeConfig = ''
        options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
    '';

    programs.steam = {
        enable = true;
        gamescopeSession.enable = true;
        protontricks.enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
    };

    #systemd.services.nix-daemon.environment = {
    #  http_proxy = "socks5h://127.0.0.1:40000";
    #  https_proxy = "socks5h://127.0.0.1:40000";
    #  all_proxy = "socks5h://127.0.0.1:40000";
    #};

    #services.cloudflare-warp.enable = true;
    #networking.firewall.checkReversePath = "loose";

    services.resolved.enable = true;
    #services.resolved.settings.Resolve = {
    #  ResolveUnicastSingleLabel = true;
    #};
    networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];
    networking.networkmanager.dns = "systemd-resolved";
    #networking.firewall.trustedInterfaces = [ "CloudflareWARP" ];

    # TODO: Delete, just testing if it works
    #networking.firewall.allowedTCPPorts = [ 8080 ];
    #services.planer-pk = {
    #    enable = true;
    #    port = 8080;
    #    apiBaseUrl = "http://localhost:8080/api";

    #    calendarCredentialsPath = "/home/frytak/ProgrammingProjects/GoogleCalendarTimetable/credentials.json";
    #    environmentFile = "/home/frytak/ProgrammingProjects/GoogleCalendarTimetable/.env"; 
    #};

    services.gnome.gnome-keyring.enable = true;
    security.pam.services.login.enableGnomeKeyring = true;

    # Enable default system configuration
    modules.system = {
        boot_loader.enable = true;
        home-manager.enable = true;
        nix_settings.enable = true;
        users.enable = true;
        locales.enable = true;
        fonts.enable = true;
        sound.enable = true;
        network-manager.enable = true;
        bluetooth.enable = true;
        printers.enable = true;
        hyprland.enable = true;

        graphics = {
            enable = true;
            intelBusId = "PCI:0:2:0";
        };
        openssh.enable = true;
        avahi.enable = true;
        databases = {
            enable = true;
            mysql.enable = true;
        };
    };

    # For shell
    services.geoclue2.enable = true;

    programs.nix-ld.enable = true;

    boot.tmp.useTmpfs = true;

    services.flatpak.enable = true;

    security.polkit.enable = true;

    # TODO: After power is restored, hibernate

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

    hardware.uinput.enable = true;

    environment.systemPackages = with pkgs; [
        wireguard-tools
        proton-vpn
    ];

    hardware.sane.enable = true; # enables support for SANE scanners

    virtualisation.docker.enable = true;
    #virtualisation.docker.daemon.settings = {
    #    runtimes = {
    #        nvidia = {
    #            path = "/nix/store/01a3h4vvbg4c9y9xm140ldm3hjfd99py-nvidia-container-toolkit-1.17.6-tools/bin/nvidia-container-runtime";
    #            runtimeArgs = [];
    #        };
    #    };
    #};
    #virtualisation.docker.extraOptions = "--default-runtime=nvidia";
    #hardware.nvidia-container-toolkit.enable = true;
    #environment.etc."docker/daemon.json".text = ''
    #  {
    #    "default-runtime": "nvidia",
    #    "runtimes": {
    #      "nvidia": {
    #        "path": "/nix/store/01a3h4vvbg4c9y9xm140ldm3hjfd99py-nvidia-container-toolkit-1.17.6-tools/bin/nvidia-container-runtime",
    #        "runtimeArgs": []
    #      }
    #    }
    #  }
    #'';

    services.input-remapper.enable = true;
}
