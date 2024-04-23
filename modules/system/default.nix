{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.system;
in

{
    imports = [
	./users

        ./boot
	./fonts
	./networking

        ./displayManagers
	./lemurs
	./gcc
	./wl-clipboard
	./swaybg
	./steam
	./mgba
    ];

    options.modules.system = {
        enable = lib.mkEnableOption "Frytaks' system defaults";
	defaultPackages = lib.mkOption {
            type = lib.types.bool;
	    default = false;
	    description = "Whether to enable packages installed by default on NixOS";
	};
    };


    config = lib.mkIf config.modules.system.enable {
        # Enable flakes and new Nix CLI.
        nix.settings.experimental-features = [ "nix-command" "flakes" ];
    }
    //
    lib.mkIf (!moduleConfig.defaultPackages) {
        # Remove unecessary preinstalled packages.
        environment.defaultPackages = [ ];
        services.xserver.desktopManager.xterm.enable = false;
    };
}
