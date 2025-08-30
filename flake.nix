{
    description = "Configuration of Frytak's NixOS.";
    
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
        nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
        
        home-manager = {
            url = "github:nix-community/home-manager/release-25.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        firefox-addons = {
            url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        mcmojave-hyprcursor = {
            url = "github:libadoxon/mcmojave-hyprcursor";
        };

        tbsm = {
            url = "github:Frytak/NixFlake-TBSM";
            inputs.nixpkgs.follows = "nixpkgs";
            inputs.home-manager.follows = "nixpkgs";
        };

        nixvim = {
            url = "github:nix-community/nixvim/nixos-25.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        hyprland-qt-support = {
            url = "github:hyprwm/hyprland-qt-support";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        youtube-music-mpris = {
            url = "github:Frytak/YoutubeMusicMPRIS";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        firefox = {
            url = "github:nix-community/flake-firefox-nightly";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };
    
    outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs:
    let
        overlays = [
            (final: prev: {
                btop = prev.btop.override { cudaSupport = true; };
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

                        # Packages from unstable
                        unstablePkgs = nixpkgs-unstable.legacyPackages."x86_64-linux";
                    };
                };
            };
        in (system "BBM")
        // (system "Pavilion");
    };
}
