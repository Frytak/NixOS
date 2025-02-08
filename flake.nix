{
    description = "Configuration of Frytak's NixOS.";
    
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
        
        home-manager = {
            url = "github:nix-community/home-manager/release-24.11";
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
    };
    
    outputs = { nixpkgs, home-manager, ... }@inputs:
    let
        system = "x86_64-linux";
        overlays = [
            (final: prev: {
                btop = prev.btop.override { cudaSupport = true; };
                lmstudio = prev.lmstudio.override { version = "0.3.8"; };
            })
        ];
        pkgs = import nixpkgs { inherit system overlays; };
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
                        inherit inputs;
                        systemName = systemName;
                    };
                };
            };
        in (system "BBM")
        // (system "Pavilion");
    };
}
