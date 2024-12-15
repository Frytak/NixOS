{ config, lib, pkgs, systemName, ... }:

{
    imports = [
        ./boot_loader.nix
        ./fonts.nix
        ./hyprland.nix
        ./locales.nix
        ./sound.nix
        ./users.nix
        ./bluetooth.nix
    ];

    networking.hostName = systemName;

    # Remove unecessary preinstalled packages.
    environment.defaultPackages = [ ];
    services.xserver.desktopManager.xterm.enable = false;

    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    environment.systemPackages = with pkgs; [
        vim
        neovim
        git
    ];
}
