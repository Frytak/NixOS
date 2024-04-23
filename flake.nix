{
    description = "A simple NixOS flake";
    
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
        
        home-manager = {
            url = "github:nix-community/home-manager/release-23.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };
    
    outputs = { nixpkgs, home-manager, ... }@inputs:
    let
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system};
    in
    {
        nixosConfigurations = {
            PavilionHP = nixpkgs.lib.nixosSystem {
                specialArgs = { inherit inputs; };
                modules = [ ./hosts/PavilionHP ];
            };
        };
    };
}
