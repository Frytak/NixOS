{ config, lib, pkgs, systemName, ... }:

{
    imports = [
        ./boot_loader.nix
        ./fonts.nix
        ./hyprland.nix
        ./locales.nix
        ./sound.nix
        ./users.nix
        ./avahi.nix
        ./bluetooth.nix
        ./databases.nix
        ./graphics.nix
        ./home_manager.nix
        ./network_manager.nix
        ./nix_settings.nix
        ./ollama.nix
        ./openssh.nix
        ./printers.nix
    ];

    networking.hostName = systemName;

    # Remove unecessary preinstalled packages.
    environment.defaultPackages = [ ];
    services.xserver.desktopManager.xterm.enable = false;

    environment.systemPackages = with pkgs; [
        vim
        neovim
        git
    ];

    programs.nh = {
        enable = true;
        clean.enable = true;
        clean.extraArgs = "--keep-since 4d --keep 3";
        flake = "/etc/nixos";
    };
}
