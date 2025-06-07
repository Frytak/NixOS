{ config, lib, pkgs, options, inputs, ... }:

let
    moduleConfig = config.modules.home.firefox;
    icons = {
        nixos = "https://icon-icons.com/downloadimage.php?id=170910&root=2699/ICO/512/&file=nixos_logo_icon_170910.ico";
    };
in

{
    options.modules.home.firefox = {
        enable = lib.mkEnableOption "Firefox";
    };
    
    config = lib.mkIf moduleConfig.enable {
        home.sessionVariables = {
            MOZ_ENABLE_WAYLAND = 1; 
        };

        programs.firefox = {
            enable = true;

            package = pkgs.latest.firefox-nightly-bin;

            profiles = {
                frytak = {
                    name = "Frytak";

                    settings = {
                        # Open previous session on startup
                        "browser.startup.page" = 3;

                        # Automatically enable extensions
                        "extensions.autoDisableScopes" = 0;

                        # Disable shortucts (together with the sponsored ones)
                        "browser.newtabpage.activity-stream.showSponsored" = false;
                        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
                        "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts" = false;
                        "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = false;
                        "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = false;
                        "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
                        "browser.newtabpage.activity-stream.section.highlights.includeVisited" = false;
                        "browser.newtabpage.activity-stream.feeds.system.topsites" = false;
                        "browser.newtabpage.activity-stream.feeds.topsites" = false;

                        # Disable search bar on a new tab
                        "browser.newtabpage.activity-stream.showSearch" = false;
                    };

                    extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
                        ublock-origin
                        darkreader
                        sponsorblock
                        youtube-shorts-block
                        return-youtube-dislikes
                        web-archives
                        tridactyl
                    ];

                    # All bookmarks should be on the toolbar
                    bookmarks = {
                        force = true;
                        settings = [{ name = "toolbar"; toolbar = true; bookmarks = [
                            {
                                name = "Nix";
                                bookmarks = [
                                    {
                                        name = "Manual";
                                        url = "https://nixos.org/manual/nixos/stable";
                                    }
                                    
                                    {
                                        name = "Packages";
                                        url = "https://search.nixos.org/packages";
                                    }
                                    
                                    {
                                        name = "Home Manager Options";
                                        url = "https://home-manager-options.extranix.com/";
                                    }
                                ];
                            }

                            {
                                name = "Mail";
                                bookmarks = [
                                    {
                                        name = "Gmail";
                                        url = "https://mail.google.com/mail/u/0/#inbox";
                                    }

                                    {
                                        name = "Outlook";
                                        url = "https://outlook.live.com/mail/0/";
                                    }
                                ];
                            }

                            {
                                name = "Git";
                                bookmarks = [
                                    {
                                        name = "GitHub";
                                        url = "https://github.com/Frytak?tab=repositories";
                                    }

                                    {
                                        name = "GitLab";
                                        url = "https://gitlab.com/";
                                    }
                                ];
                            }

                            {
                                name = "Map";
                                url = "https://www.google.pl/maps/@49.6589875,20.9944038,14z?entry=ttu";
                            }

                            {
                                name = "YouTube";
                                url = "https://www.youtube.com";
                            }
                        ];}];
                    };
                };
            };
            
            # `Locked` prevents changing these options in the browsers direectly. It enforces changing
            # them in this configuration file.
            #
            # For more information on policies visit https://mozilla.github.io/policy-templates/ 
            #policies = {
            #    FirefoxHome = {
            #        Locked = true;
            #        Search = false;
            #        TopSites = false;
            #        SponsoredTopSites = false;
            #        Highlights = false;
            #        Pocket = false;
            #        SponsoredPocket = false;
            #        Snippets = false;
            #    };
            #    
            #    Homepage = {
            #       Locked = true;
            #       StartPage = "homepage";
            #    };
            #    
            #    # TODO: Change to ManagedBookmarks
            #    
            #    SearchEngines = {
            #        Add = [
            #            {
            #                Name = "Google";
            #                URLTemplate = "https://www.google.com/search?q={searchTerms}";
            #                Method = "GET";
            #            }
            #        ];
            #        Default = "Google";
            #    };
            #    
            #    # Extensions and themes to be installed
            #    ExtensionSettings = {
            #        "*" = {
            #            installation_mode = "blocked";
            #            blocked_install_message = "If you want to install an extension of any kind. Do it by specifying the extension in the Nix config file of firefox.";
            #            default_area = "menupanel";
            #            allowed_types = ["extension" "theme"];
            #        };
            #        
            #        # Add-on for easy lookup of an extensions ID and install_url.
            #        # https://github.com/mkaply/queryamoid/releases
            #        "queryamoid@kaply.com" = {
            #            installation_mode = "allowed";
            #        };
            #        
            #        # Enable dark theme
            #        "firefox-compact-dark@mozilla.org" = {
            #            installation_mode = "force_installed";
            #        };
            #        
            #        # uBlockOrigin
            #        "uBlock0@raymondhill.net" = {
            #            installation_mode = "force_installed";
            #            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            #        };
            #        
            #        # Grammarly
            #        "87677a2c52b84ad3a151a4a72f5bd3c4@jetpack" = {
            #            installation_mode = "force_installed";
            #            install_url = "https://addons.mozilla.org/firefox/downloads/latest/grammarly-1/latest.xpi";
            #        };
            #        
            #        # Sponsor Block
            #        "sponsorBlocker@ajay.app" = {
            #            installation_mode = "force_installed";
            #            install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
            #        };
            #        
            #        # Dark Reader
            #        "addon@darkreader.org" = {
            #            installation_mode = "force_installed";
            #            install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
            #        };
            #        
            #        # Hide YouTube Shorts
            #        "{88ebde3a-4581-4c6b-8019-2a05a9e3e938}" = {
            #            installation_mode = "force_installed";
            #            install_url = "https://addons.mozilla.org/firefox/downloads/latest/hide-youtube-shorts/latest.xpi";
            #        };
            #    };
            #    
            #    # Other settings
            #    NoDefaultBookmarks = true;
            #    AppAutoUpdate = false;
            #    DisablePocket = true;
            #    DisableSetDesktopBackground = true;
            #    DisableTelemetry = true;
            #    DisplayBookmarksToolbar = "newtab";
            #    DontCheckDefaultBrowser = true;
            #    DownloadDirectory = "$HOME/Downloads";
            #    HardwareAcceleration = true;
            #    OfferToSaveLogins = true;
            #    SearchSuggestEnabled = true;
            #};
        };

        #home.packages = [
        #    # TODO
        #    (pkgs.wrapFirefox (pkgs.firefox-unwrapped.override { pipewireSupport = true;}) {})
        #];
    };
}
