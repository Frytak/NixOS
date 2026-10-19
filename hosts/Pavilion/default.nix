{ config, inputs, pkgs, systemName, lib, ... }@args:

{
    imports = [
        ./hardware-configuration.nix
        ../../modules/system
    ];

    system.stateVersion = "26.05";

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
            amdgpuBusId = "PCI:5:0:0";
        };
        openssh = {
            enable = true;
            permitTunnel = true;
        };
        avahi.enable = true;
        databases = {
            enable = true;
            mysql.enable = true;
        };
    };

    # The ELAN0718 touchpad is exposed through both I2C-HID and PS/2. The
    # I2C-HID interface repeatedly fails with EREMOTEIO (-121), while the
    # Elantech PS/2 interface initializes correctly. Avoid the broken
    # duplicate so libinput/Hyprland uses the working interface.
    boot.blacklistedKernelModules = [ "i2c_hid_acpi" ];

    # TODO: Tablet drivers
    hardware.opentabletdriver.enable = true;

    services.flatpak.enable = true;

    virtualisation.docker.enable = true;

    services = {
        input-remapper.enable = true;
        logmein-hamachi.enable = true;
    };
}
