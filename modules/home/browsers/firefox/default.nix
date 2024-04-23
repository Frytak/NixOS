{ config, lib, pkgs, options, ... }:

let
    moduleConfig = config.modules.firefox;
    icons = {
        nixos = "https://icon-icons.com/downloadimage.php?id=170910&root=2699/ICO/512/&file=nixos_logo_icon_170910.ico";
    };
in

{
    options.modules.firefox = {
        enable = lib.mkEnableOption "firefox";
    };
    
    config = lib.mkIf moduleConfig.enable {
        programs.firefox = {
            enable = true;
            
            # `Locked` prevents changing these options in the browsers direectly. It enforces changing
            # them in this configuration file.
            #
            # For more information on policies visit https://mozilla.github.io/policy-templates/ 
            policies = {
                FirefoxHome = {
                    Locked = true;
                    Search = false;
                    TopSites = false;
                    SponsoredTopSites = false;
                    Highlights = false;
                    Pocket = false;
                    SponsoredPocket = false;
                    Snippets = false;
                };
                
                Homepage = {
                   Locked = true;
                   StartPage = "homepage";
                };
                
                # TODO: Change to ManagedBookmarks
                Bookmarks = [
                    # NixOS Folder
                    {
                        Title = "Manual";
                        URL = "https://nixos.org/manual/nixos/stable";
                        Folder = "NixOS";
                        Favicon = icons.nixos;
                    }
                    
                    {
                        Title = "Packages";
                        URL = "https://search.nixos.org/packages";
                        Folder = "NixOS";
                        Favicon = icons.nixos;
                    }
                    
                    {
                        Title = "MyNixOS";
                        URL = "https://mynixos.com/";
                        Folder = "NixOS";
                        Favicon = icons.nixos;
                    }
                    
                    {
                        Title = "Home Manager Options";
                        URL = "https://home-manager-options.extranix.com/";
                        Folder = "NixOS";
                        Favicon = icons.nixos;
                    }
                    
                    # YouTube
                    {
                        Title = "YouTube";
                        URL = "https://www.youtube.com";
                    }
                ];
                
                SearchEngines = {
                    Add = [
                        {
                            Name = "Google";
                            URLTemplate = "https://www.google.com/search?q={searchTerms}";
                            Method = "GET";
                        }
                    ];
                    Default = "Google";
                };
                
                # Extensions and themes to be installed
                ExtensionSettings = {
                    "*" = {
                        installation_mode = "blocked";
                        blocked_install_message = "If you want to install an extension of any kind. Do it by specifying the extension in the Nix config file of firefox.";
                        default_area = "menupanel";
                        allowed_types = ["extension" "theme"];
                    };
                    
                    # Add-on for easy lookup of an extensions ID and install_url.
                    # https://github.com/mkaply/queryamoid/releases
                    "queryamoid@kaply.com" = {
                        installation_mode = "allowed";
                    };
                    
                    # Enable dark theme
                    "firefox-compact-dark@mozilla.org" = {
                        installation_mode = "force_installed";
                    };
                    
                    # uBlockOrigin
                    "uBlock0@raymondhill.net" = {
                        installation_mode = "force_installed";
                        install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
                    };
                    
                    # Grammarly
                    "87677a2c52b84ad3a151a4a72f5bd3c4@jetpack" = {
                        installation_mode = "force_installed";
                        install_url = "https://addons.mozilla.org/firefox/downloads/latest/grammarly-1/latest.xpi";
                    };
                    
                    # Sponsor Block
                    "sponsorBlocker@ajay.app" = {
                        installation_mode = "force_installed";
                        install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
                    };
                    
                    # Dark Reader
                    "addon@darkreader.org" = {
                        installation_mode = "force_installed";
                        install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
                    };
                    
                    # Hide YouTube Shorts
                    "{88ebde3a-4581-4c6b-8019-2a05a9e3e938}" = {
                        installation_mode = "force_installed";
                        install_url = "https://addons.mozilla.org/firefox/downloads/latest/hide-youtube-shorts/latest.xpi";
                    };
                };
                
                # Other settings
                NoDefaultBookmarks = true;
                AppAutoUpdate = false;
                DisablePocket = true;
                DisableSetDesktopBackground = true;
                DisableTelemetry = true;
                DisplayBookmarksToolbar = "newtab";
                DontCheckDefaultBrowser = true;
                DownloadDirectory = "$HOME/Downloads";
                HardwareAcceleration = true;
                OfferToSaveLogins = true;
                SearchSuggestEnabled = true;
            };
        };
    };
}
