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

            # While updating from 25.11 to 26.05 (new default behavior)
            configPath = "${config.xdg.configHome}/mozilla/firefox";

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

                        # TODO: Testing if it helps with problems rendering PDFs or websites like Google Docs or Google Sheets
                        "gfx.webrender.compositor" = true;
                    };

                    extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
                        ublock-origin
                        darkreader
                        sponsorblock
                        youtube-shorts-block
                        return-youtube-dislikes
                        web-archives
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
        };
    };
}
