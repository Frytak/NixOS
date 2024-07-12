{
    description = "Configuration of Frytaks' NixOS.";
    
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
        nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
        
        home-manager = {
            url = "github:nix-community/home-manager/release-24.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        firefox-addons = {
            url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };
    
    outputs = { nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs:
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
