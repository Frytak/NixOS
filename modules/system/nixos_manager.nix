# Creates a `nixos_manager` group and sets up the `/etc/nixos` directory,
# as well as it's children to be edditable by users in the group.
#
# WARNING! Shouldn't be used with symlinks pointing to a directory.
# The `Z` option of systemd `tmpfiles.d` will travers them as well.

{ config, ... }:

let
    GROUP = "nixos_manager";
    DIR_MODE = "775";
    FILE_MODE = "664";
in

{
    config = {
        # Create the `GROUP`
        users.groups.${GROUP} = {};

        # Change every child of `/etc/nixos` and itself to have the `GROUP` set
        systemd.tmpfiles.settings = {
            "nixos_manager" = {
                "/etc/nixos"."Z" = {
                    user = "root";
                    group = GROUP;
                };

                # Files in the root directory (`/etc/nixos`) should be set manually
                "/etc/nixos/flake.nix"."z" = {
                    user = "root";
                    group = GROUP;
                    mode = "664";
                };
            };
        };

        systemd.tmpfiles.rules = let
            # Make the whole directory and it's children edditable by users in the `GROUP`
            nix_files_mod = path: depth:
                # Set `DIR_MODE` for the specified directory and it's children (this includes files, as `tmpfiles` doesn't support more complex path expressions. This is overriden by the next lines)
                [
                    "'z' '/etc/nixos/${path}' '${DIR_MODE}' '-' '-' '-'"
                    "'Z' '/etc/nixos/${path}/*/' '${DIR_MODE}' '-' '-' '-'"
                ]
                ++
                # Set `FILE_MODE` for each `.nix` file
                (builtins.concatLists (builtins.genList (
                    index: let
                        xTimesString' = num: base_string: new_string: if num <= 0 then new_string else xTimesString' (num - 1) base_string (new_string + base_string);
                        xTimesString = num: string: xTimesString' num string "";
                    in [
                        "'z' '/etc/nixos/${path}/${xTimesString index "*/"}*.nix' '${FILE_MODE}' '-' '-' '-'"
                    ]
                ) depth));
        in nix_files_mod "hosts" 4
        ++ nix_files_mod "modules" 10
        ++ nix_files_mod "templates" 4
        ++ nix_files_mod "users" 4;
    };
}
