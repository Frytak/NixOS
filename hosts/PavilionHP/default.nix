{ config, inputs, pkgs, ... }:

{
    imports = [
        inputs.home-manager.nixosModules.default
        ./hardware-configuration.nix
	../../modules/system
	#../../modules/home/displayManagers/wayland/sway
    ];

    config = {
        system.stateVersion = "23.11";

        # Allow unfree software
        nixpkgs.config.allowUnfree = true;	

	hardware = {
	    nvidia = {
	        modesetting.enable = true;
		nvidiaSettings = true;
	        package = config.boot.kernelPackages.nvidiaPackages.stable;
		prime = {
		    nvidiaBusId = "PCI:1:0:0";
		    amdgpuBusId = "PCI:5:0:0";
		    offload = {
		        enable = true;
		        enableOffloadCmd = true;
		    };
		};
	    };
	    opengl = {
	        enable = true;
                driSupport = true;
                driSupport32Bit = true;
	    };
	};

        home-manager = {
            useUserPackages = true;
            useGlobalPkgs = true;
            extraSpecialArgs = {
                inherit inputs;
            };
            users = {
	        frytak = import ../../modules/home/users/frytak;
	    };
        };

        #modules.wayland.sway.additionalConfig = ''
	#    # Taki test
        #    output HDMI-A-1 mode 1920x1080@60Hz
	#'';


        # Set up hostname.
        networking.hostName = "frytkolot";

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
        console = {
            font = "Lat2-Terminus16";
            keyMap = "pl";
        };

	# Enable for sway.
	security.polkit.enable = true;
        nix.settings.experimental-features = [ "nix-command" "flakes" ];

	modules.system = {
	    enable = true;
	    boot.enable = true;
	    fonts.enable = true;
	    networking.enable = true;
	    users.enableAll = true;
	    #gcc.enable = true;
	    "wl-clipboard".enable = true;
	    swaybg.enable = true;
	    #steam.enable = true;
	    #mgba.enable = true;
	    #lemurs.enable = true;
	    #displayManagers.wayland.sway.enable = true;
	};

	# Testing stuff out
	environment.systemPackages = [ pkgs.lshw ];
    };
}
