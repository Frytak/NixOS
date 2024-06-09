{
    description = "Template for development flake templates! (Templateception)";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
        nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    outputs = { self, nixpkgs, ... }:
    let
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system};
        projectName = "an unnamed project";
    in
    {
        # Shell
        devShells.${system}.default = pkgs.mkShell {
            nativeBuildInputs = with pkgs; [
                # Older IDE (with CLI built in)
                pkgs.arduino

                # Newer IDE (without CLI)
                pkgs-unstable.arduino-ide
            ];

            shellHook = ''
                printf '\x1b[36m\x1b[1m\x1b[4mTime to develop ${projectName}!\x1b[0m\n\n'
            '';
        };
    };
}
