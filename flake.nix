{
    description = "Configuration of Frytak's NixOS.";
    
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        firefox-addons = {
            url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        mcmojave-hyprcursor = {
            url = "github:libadoxon/mcmojave-hyprcursor";
        };
    };
    
    outputs = { nixpkgs, home-manager, ... }@inputs:
    let
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system};
    in
    {
        nixosConfigurations = let
            system = systemName: {
                ${systemName} = nixpkgs.lib.nixosSystem {
                    modules = [
                        ./modules/system/nixos_manager
                        ./hosts/${systemName}
                        home-manager.nixosModules.home-manager
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
