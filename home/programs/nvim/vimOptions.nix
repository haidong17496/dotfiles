{
    programs.nixvim = {
        globals.mapleader = " ";

        opts = {
            # Line numbers
            number = true;
            relativenumber = true;

            # Indentation
            tabstop = 4;
            shiftwidth = 4;
            expandtab = true;
            smartindent = true;

            # Line wrapping & Length marker
            wrap = true;
            linebreak = true;
            colorcolumn = "79";

            # Search
            ignorecase = true;
            smartcase = true;

            # UI
            termguicolors = true;
            scrolloff = 8;
            cursorline = true;

            # Undo
            undofile = true;
        };

        keymaps = [
            # --- Move Lines (ThePrimeagen style) ---
            {
                mode = "v";
                key = "J";
                action = ":m '>+1<CR>gv=gv";
                options.desc = "Move selected lines down";
            }
            {
                mode = "v";
                key = "K";
                action = ":m '<-2<CR>gv=gv";
                options.desc = "Move selected lines up";
            }
            # Keep cursor in place when joining lines
            {
                mode = "n";
                key = "J";
                action = "mzJ`z";
                options.desc = "Join lines keeping cursor";
            }

            # --- Window Navigation ---
            {
                mode = "n";
                key = "<C-h>";
                action = "<C-w>h";
                options.desc = "Focus Left";
            }
            {
                mode = "n";
                key = "<C-l>";
                action = "<C-w>l";
                options.desc = "Focus Right";
            }
            {
                mode = "n";
                key = "<C-j>";
                action = "<C-w>j";
                options.desc = "Focus Down";
            }
            {
                mode = "n";
                key = "<C-k>";
                action = "<C-w>k";
                options.desc = "Focus Up";
            }

            # Clear search highlights with Esc
            {
                mode = "n";
                key = "<Esc>";
                action = "<cmd>nohlsearch<CR>";
            }
        ];
    };
}
