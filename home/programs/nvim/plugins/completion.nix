{
    programs.nixvim.plugins = {
        # The database of snippets
        friendly-snippets.enable = true;

        blink-cmp = {
            enable = true;

            settings = {
                keymap = {
                    preset = "default";

                    # --- Navigation ---
                    "<C-n>" = [ "select_next" "fallback" ];
                    "<C-p>" = [ "select_prev" "fallback" ];

                    # --- Control ---
                    "<C-e>" = [ "hide" ];
                    "<C-y>" = [ "select_and_accept" ];

                    # Prevent Enter from accepting
                    "<CR>" = [ "fallback" ];

                    # --- Documentation ---
                    "<C-space>" = [ "show" "show_documentation" "hide_documentation" ];

                    # --- Snippets ---
                    "<Tab>" = [ "snippet_forward" "fallback" ];
                    "<S-Tab>" = [ "snippet_backward" "fallback" ];
                };

                appearance = {
                    use_nvim_cmp_as_default = true;
                    nerd_font_variant = "mono";
                };

                sources.default = [ "lsp" "path" "snippets" "buffer" ];
                signature.enabled = true;
            };
        };
    };
}
