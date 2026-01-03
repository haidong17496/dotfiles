{
    programs.nixvim = {
        plugins.telescope = {
            enable = true;

            extensions = {
                fzf-native.enable = true;
                ui-select.enable = true;
            };

            settings.defaults = {
                file_ignore_patterns = [
                    "^.git/"
                    "^node_modules/"
                    "^target/"
                ];
                layout_config = {
                    prompt_position = "top";
                };
                sorting_strategy = "ascending";
            };
        };

        keymaps = [
            # --- File Search ---
            {
                mode = "n";
                key = "<leader>ff";
                action = "<cmd>Telescope find_files<CR>";
                options.desc = "Find files";
            }
            {
                mode = "n";
                key = "<leader>fg";
                action = "<cmd>Telescope live_grep<CR>";
                options.desc = "Live grep";
            }
            {
                mode = "n";
                key = "<leader>fb";
                action = "<cmd>Telescope buffers<CR>";
                options.desc = "Find buffers";
            }
            {
                mode = "n";
                key = "<leader>fh";
                action = "<cmd>Telescope help_tags<CR>";
                options.desc = "Help tags";
            }

            # --- LSP Lists ---
            {
                mode = "n";
                key = "gr";
                action = "<cmd>Telescope lsp_references<CR>";
                options.desc = "[LSP] References";
            }
            {
                mode = "n";
                key = "gi";
                action = "<cmd>Telescope lsp_implementations<CR>";
                options.desc = "[LSP] Implementations";
            }
            {
                mode = "n";
                key = "<leader>ds";
                action = "<cmd>Telescope lsp_document_symbols<CR>";
                options.desc = "[LSP] Document symbols";
            }
            {
                mode = "n";
                key = "<leader>dt";
                action = "<cmd>Telescope lsp_type_definitions<CR>";
                options.desc = "[LSP] Type definitions";
            }
        ];
    };
}
