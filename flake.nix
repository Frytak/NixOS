{
    description = "Configuration of Frytak's NixOS.";
    
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
        nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
        
        home-manager = {
            url = "github:nix-community/home-manager/release-26.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        firefox-addons = {
            url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        mcmojave-hyprcursor = {
            url = "github:libadoxon/mcmojave-hyprcursor";
        };

        hyprland-qt-support = {
            url = "github:hyprwm/hyprland-qt-support";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        frytak-quickshell = {
            url = "path:/home/frytak/ProgrammingProjects/QuickshellConfig";
            inputs.nixpkgs.follows = "nixpkgs";
            inputs.home-manager.follows = "home-manager";
        };

        frytak-nixvim = {
            url = "path:/home/frytak/ProgrammingProjects/NixvimConfig";
            inputs.nixpkgs.follows = "nixpkgs";
            inputs.home-manager.follows = "home-manager";
        };

        vicinae-extensions = {
            url = "github:vicinaehq/extensions";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        noctalia = {
            url = "github:noctalia-dev/noctalia";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };
    
    outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs:
    let
        overlays = [
            (final: prev: {
                btop = prev.btop.override { cudaSupport = true; };

                clapper = prev.clapper.overrideAttrs (oldAttrs: {
                    buildInputs = (oldAttrs.buildInputs or []) ++ [
                        prev.gst_all_1.gst-plugins-bad
                        prev.gst_all_1.gst-plugins-ugly
                        prev.gst_all_1.gst-libav
                    ];
                });

                # Packages from unstable
                unstable = import nixpkgs-unstable {
                    system = prev.stdenv.hostPlatform.system;
                    config.allowUnfree = true; 
                };
            })
        ];
    in
    {
        nixosConfigurations = let
            system = systemName: {
                ${systemName} = nixpkgs.lib.nixosSystem {
                    modules = [
                        ./modules/system/nixos_manager.nix
                        ./hosts/${systemName}
                        home-manager.nixosModules.home-manager
                        {
                            nixpkgs.overlays = overlays;
                        }
                    ];
                    specialArgs = {
                        inherit self;
                        inherit inputs;
                        inherit systemName;
                    };
                };
            };
        in (system "BBM")
        // (system "Pavilion");
    };
}
