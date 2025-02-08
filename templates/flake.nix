{
    description = "Flake template.";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

        flake-utils = {
            url = "github:numtide/flake-utils";
        };
    };

    outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
    let
        pkgs = nixpkgs.legacyPackages.${system};
        projectName = "an unnamed project";
    in
    {
        devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
            ];

            nativeBuildInputs = with pkgs; [
            ];

            shellHook = ''
                printf '\x1b[36m\x1b[1m\x1b[4mTime to develop ${projectName}!\x1b[0m\n\n'
            '';
        };

        packages.${projectName} = pkgs.stdenv.mkDerivation {
            pname = projectName;
            version = "";

            src = pkgs.fetchFromGitHub {
                owner = "Frytak";
                repo = projectName;
                rev = "";
                hash = "";
            };

            installPhase = ''
                mkdir -p $out/bin
                install -pDm775 src/${projectName} $out/bin/
            '';
        };
    });
}
