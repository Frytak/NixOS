{ config, inputs, lib, pkgs, unstablePkgs, systemName, self, ... }@args:

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

            extraSpecialArgs = {
                inherit self;
                inherit inputs;
                inherit systemName;
                inherit unstablePkgs;
            };

            users = let
                # God bless them https://stackoverflow.com/a/54505212/16454500
                recursiveMerge = attrList:
                let f = attrPath:
                    lib.zipAttrsWith (n: values:
                        if lib.tail values == []
                            then lib.head values
                        else if lib.all lib.isList values
                            then lib.unique (lib.concatLists values)
                        else if lib.all lib.isAttrs values
                            then f (attrPath ++ [n]) values
                        else lib.last values
                    );
                in f [] attrList;
                user = user: { ${user} = (recursiveMerge [(import "${self}/hosts/${systemName}/home.nix" args) (import "${self}/users/${user}" args)]); };
            in (user "root")
            // (user "frytak");
        };
    };
}
