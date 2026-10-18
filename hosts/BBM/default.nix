{ config, pkgs, ... }:

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

    services.resolved.enable = true;
    networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];
    networking.networkmanager.dns = "systemd-resolved";

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
        ollama.enable = true;
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

    # Suspend after 30 minutes of inactivity, then hibernate 30 minutes later.
    services.logind.settings.Login = {
        IdleAction = "suspend-then-hibernate";
        IdleActionSec = "30min";
    };

    systemd.sleep.settings.Sleep.HibernateDelaySec = "30min";

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

    services.input-remapper.enable = true;
}
