{ config, inputs, pkgs, systemName, lib, ... }@args:

{
    imports = [
        ./hardware-configuration.nix
        ../../modules/system
    ];

    system.stateVersion = "23.11";
    modules.system = {
        # Enable default system configuration
        boot_loader.enable = true;
        users.enable = true;
        locales.enable = true;
        fonts.enable = true;
        sound.enable = true;

        hyprland.enable = true;
    };

    # Graphic drivers
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware = {
        opengl = {
            enable = true;
            driSupport = true;
            driSupport32Bit = true;
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
                amdgpuBusId = "PCI:5:0:0";

                sync.enable = true;
            };
        };
    };

    environment.systemPackages = with pkgs; [ ];

    # Printer
    services.printing.enable = true;
    services.printing.drivers = with pkgs; [ cnijfilter_4_00 ];

    # Network manager
    networking.networkmanager.enable = true;
    networking.firewall = {
        enable = true;
        allowedTCPPorts = [ 2855 ];
        allowedUDPPorts = [ 2855 ];
    };

    virtualisation.docker.enable = true;
    services.input-remapper.enable = true;
    services.postgresql.enable = true;
    services.logmein-hamachi.enable = true;
    services.openssh.enable = true;
    services.avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
    };

    home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;

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
}
