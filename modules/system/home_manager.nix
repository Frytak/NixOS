{ config, inputs, lib, systemName, self, ... }:

let
    moduleConfig = config.modules.system.home-manager;
in

{
    options.modules.system.home-manager = {
        enable = lib.mkEnableOption "Home-manager";
    };

    config = lib.mkIf moduleConfig.enable {
        home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;

            sharedModules = [
                ../home
                inputs.frytak-nixvim.homeModules.default
                inputs.noctalia.homeModules.default
            ];

            extraSpecialArgs = {
                inherit self;
                inherit inputs;
                inherit systemName;
            };

            # Set up home-manager host and user configurations
            users = let
                user = user: {
                    ${user} = {
                        imports = [
                            "${self}/hosts/${systemName}/home.nix"
                            "${self}/users/${user}"
                        ];
                    };
                };
            in (user "root")
            // (user "frytak");
        };
    };
}
