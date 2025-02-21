{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.home.starship;
in

{
    options.modules.home.starship = {
        enable = lib.mkEnableOption "starship";
    };
    
    config = lib.mkIf moduleConfig.enable {
        programs.starship = {
            enable = true;
            settings = {
                palette = "frytak";
                palettes = {
                    frytak = {
                        g1 = "#ad3232";
                        g2 = "#b53162";
                        g3 = "#ab448f";
                        g4 = "#8e5db2";
                        g5 = "#6373c5";
                    };
                };

                format = lib.concatStrings [
                    "[█](fg:g1)[ $username  [](bg:g2 fg:g1)](bg:g1 fg:white bold)"
                    "[  $directory  [](bg:g3 fg:g2)](bg:g2 fg:white bold)"
                    "[  ($git_branch ) [](bg:g4 fg:g3)](bg:g3 fg:white bold)"
                    "[  ($nix_shell )($rust )($c )($elixir )($golang )($gradle )($nodejs ) [](bg:g5 fg:g4)](bg:g4 fg:white bold)"
                    "[  ($cmd_duration ) [](fg:g5)](bg:g5 fg:white bold)\n"
                    "$character"
                ];

                username = {
                    format = "$user";
                    show_always = true;
                };

                directory = {
                    read_only = "";
                    format = "$read_only $path";
                };

                character = {
                    format = "$symbol";
                    success_symbol = "[ ](bold green)";
                    error_symbol = "[ ](bold red)";
                };

                cmd_duration = {
                    format = "$duration";
                    min_time = 0;
                    show_milliseconds = true;
                };

                nix_shell.format = "$symbol$state( \($name\))";
                rust.format = "$symbol($version)";
                c.format = "$symbol($version(-$name))";
                elixir.format = "$symbol($version \(OTP $otp_version\))";
                golang.format = "$symbol($version)";
                gradle.format = "$symbol($version)";
                nodejs.format = "$symbol($version)";
                git_branch.format = "$symbol$branch(:$remote_branch)";
            };
        };
    };
}
