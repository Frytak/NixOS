{ config, lib, pkgs, ... }:

let
    moduleConfig = config.modules.home.nvim;
in

{
    options.modules.home.nvim = {
        enable = lib.mkEnableOption "Neovim";
    };
    
    config = lib.mkIf moduleConfig.enable {
        home.packages = with pkgs; [
            texlab
            latexrun
            texliveFull
        ];

        programs.nixvim = {
        	enable = true;

            colorschemes.onedark = {
				enable = true;
				settings = {
					style = "darker";
				};
			};

            # Set the <LEADER> to space-bar
            globals.mapleader = " ";

            opts = {
                # Use spaces instead of TABs
                expandtab = true;
                tabstop = 4;
                shiftwidth = 4;
                softtabstop = 0;

                autoindent = true;
                smartindent = true;

                # Relative numbers on the left
                number = true;
                relativenumber = true;

                # Word wrap
                breakindent = true;
                formatoptions = "l";
                lbr = true;
            };

            keymaps = [
                # Copy
                { mode = "n"; key = "<leader>p"; action = "\"+p"; }
                { mode = "n"; key = "<leader>P"; action = "\"+P"; }
                { mode = "v"; key = "<leader>p"; action = "\"+p"; }
                { mode = "v"; key = "<leader>P"; action = "\"+P"; }

                # Paste
                { mode = "n"; key = "<leader>y"; action = "\"+yy"; }
                { mode = "v"; key = "<leader>y"; action = "\"+y"; }

                # Exit Terminal mode
                { mode = "t"; key = "<esc>"; action = "<C-\\><C-n>"; }

                # Switch tabs
                { mode = "n"; key = "<leader>h"; action = "<cmd>tabprevious<enter>"; }
                { mode = "n"; key = "<leader>l"; action = "<cmd>tabnext<enter>"; }

                # New tab
                { mode = "n"; key = "<leader>n"; action = "<cmd>tabnew<enter>"; }

				# Switch window
                { mode = "n"; key = "<leader>wh"; action = "<C-w><C-h>"; }
                { mode = "n"; key = "<leader>wl"; action = "<C-w><C-l>"; }
                { mode = "n"; key = "<leader>wk"; action = "<C-w><C-k>"; }
                { mode = "n"; key = "<leader>wj"; action = "<C-w><C-j>"; }

                # Neo-tree navigation
                { mode = "n"; key = "<leader><leader>"; action = "<cmd>Neotree float<enter>"; }
                { mode = "n"; key = "<leader>.<leader>"; action = "<cmd>Neotree right<enter>"; }
            ];

            plugins = {
                lsp = {
                    enable = true;
                    servers = {
                        nil_ls.enable = true;
                        lua_ls.enable = true;
                        rust_analyzer = {
							installCargo = false;
							installRustc = false;
							enable = true;
						};
                    };
                };

                cmp = {
                    enable = true;
                    autoEnableSources = true;
                    settings = {
                        mapping = {
                            "<C-l>" = "cmp.mapping.confirm({select = false})";
                            "<C-h>" = "cmp.mapping.abort()";
                            "<C-k>" = "cmp.mapping.select_prev_item({behavior = 'select'})";
                            "<C-j>" = "cmp.mapping.select_next_item({behavior = 'select'})";
                            # FIXME: Cmd doesn't translate ctrl + shift
                            "<C-S-j>" = "cmp.mapping.scroll_docs(1)";
                            "<C-S-k>" = "cmp.mapping.scroll_docs(-1)";
                        };
                        sources = [
                            { name = "nvim_lsp"; }
                            { name = "path"; }
                            { name = "buffer"; }
                        ];
                    };
                };

                web-devicons.enable = true;
                lualine.enable = true;

                bufferline = {
                    enable = true;
                    settings.options.mode = "tabs";
                };

                neo-tree = {
                    enable = true;
                    enableGitStatus = true;
                    enableModifiedMarkers = true;

					window = {
						position = "current";
                        mappings = {
                            "l" = "open";
                            "h" = "close_node";
                        };
					};
                };
            };
        };
    };
}
