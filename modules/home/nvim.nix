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

            colorschemes.gruvbox = {
				enable = true;
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

                # Tabs
                { mode = "n"; key = "<leader>n"; action = "<cmd>tabnew<enter>"; }
                { mode = "n"; key = "<leader>h"; action = "<cmd>tabprevious<enter>"; }
                { mode = "n"; key = "<leader>l"; action = "<cmd>tabnext<enter>"; }
                { mode = "n"; key = "<leader>H"; action = "<cmd>tabmove -1<enter>"; }
                { mode = "n"; key = "<leader>L"; action = "<cmd>tabmove 1<enter>"; }

				# Windows
                { mode = "n"; key = "<leader>wh"; action = "<C-w><C-h>"; }
                { mode = "n"; key = "<leader>wl"; action = "<C-w><C-l>"; }
                { mode = "n"; key = "<leader>wk"; action = "<C-w><C-k>"; }
                { mode = "n"; key = "<leader>wj"; action = "<C-w><C-j>"; }

                # Telescope navigation
                { mode = "n"; key = "<leader>fb"; action = "<cmd>lua require(\"telescope\").extensions.file_browser.file_browser()<enter>"; }
                { mode = "n"; key = "<leader>ff"; action = "<cmd>lua require(\"telescope.builtin\").find_files()<enter>"; }
                { mode = "n"; key = "<leader>fg"; action = "<cmd>lua require(\"telescope.builtin\").live_grep()<enter>"; }

                # Open diagnostics window
                { mode = "n"; key = "<leader>t"; action = "<cmd>lua vim.diagnostic.open_float()<enter>"; }
            ];

            plugins = {
                lsp = {
                    enable = true;
                    servers = {
                        texlab.enable = true;
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

                telescope = {
                    enable = true;
                    extensions = {
                        file-browser = {
                            enable = true;
                            settings = {
                                hijack_netrw = true;
                                auto_depth = true;
                                mappings.n = {
                                    "c" = "require('telescope._extensions.file_browser.actions').create";
                                    "r" = "require('telescope._extensions.file_browser.actions').rename";
                                    "m" = "require('telescope._extensions.file_browser.actions').move";
                                    "y" = "require('telescope._extensions.file_browser.actions').copy";
                                    "d" = "require('telescope._extensions.file_browser.actions').remove";
                                    "o" = "require('telescope._extensions.file_browser.actions').open";
                                    "h" = "require('telescope._extensions.file_browser.actions').goto_parent_dir";
                                    "e" = "require('telescope._extensions.file_browser.actions').goto_home_dir";
                                    "w" = "require('telescope._extensions.file_browser.actions').goto_cwd";
                                    "t" = "require('telescope._extensions.file_browser.actions').change_cwd";
                                    "f" = "require('telescope._extensions.file_browser.actions').toggle_browser";
                                    "H" = "require('telescope._extensions.file_browser.actions').toggle_hidden";
                                    "s" = "require('telescope._extensions.file_browser.actions').toggle_all";
                                };
                            };
                        };
                    };
                };

                vimtex = {
                    enable = true;
                    settings.view_method = "zathura";
                };
            };
        };
    };
}
