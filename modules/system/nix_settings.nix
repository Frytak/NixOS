{ config, lib, inputs, ... }:

let
    moduleConfig = config.modules.system.nix_settings;
in

{
    options.modules.system.nix_settings = {
        enable = lib.mkEnableOption "Nix settings, pinned registry and binary caches";
    };

    config = lib.mkIf moduleConfig.enable {
        nixpkgs.config.allowUnfree = true;

        nix.settings = {
            experimental-features = [ "nix-command" "flakes" ];

            # Be resilient but do not hang forever on a flaky/slow connection.
            connect-timeout = 5;
            download-attempts = 3;
            fallback = true;

            # cache.nixos.org plus the Cachix caches used by our flake inputs,
            # so source-built packages (hyprland, nixvim, noctalia, vicinae,
            # firefox-addons, ...) are substituted instead of rebuilt locally.
            # cache.nixos.org is already provided by the NixOS default.
            substituters = [
                "https://nix-community.cachix.org"
                "https://hyprland.cachix.org"
                "https://nixvim.cachix.org"
                "https://noctalia.cachix.org"
                "https://vicinae.cachix.org"
                "https://nur.cachix.org"
                "https://frytak.cachix.org"
            ];

            # cache.nixos.org's key is already provided by the NixOS default.
            trusted-public-keys = [
                "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
                "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
                "nixvim.cachix.org-1:8xrm/43sWNaE3sqFYil49+3wO5LqCbS4FHGhMCuPNNA="
                "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
                "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
                "nur.cachix.org-1:F8+2oprcHLfsYyZBCsVJZJrPyGHwuE+EZBtukwalV7o="
                "frytak.cachix.org-1:3O6yxF13FepAf/zNiAya6rb/A84c07K9U2S6GgoSS5Q="
            ];
        };

        # Pin the unstable input in the *system* registry so `nix shell
        # nixpkgs-unstable#...` resolves to the locked revision for every user
        # (including root) without contacting the channel servers.
        # `nixpkgs` itself is already pinned to the system nixpkgs source by
        # default, so it needs no override here.
        nix.registry.nixpkgs-unstable.flake = inputs.nixpkgs-unstable;
    };
}
