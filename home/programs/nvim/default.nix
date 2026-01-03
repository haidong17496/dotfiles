{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nixvim.homeModules.nixvim
    ./vimOptions.nix

    # Plugins
    ./plugins/autopairs.nix
    ./plugins/completion.nix
    ./plugins/conform.nix
    ./plugins/lsp.nix
    ./plugins/neo-tree.nix
    ./plugins/telescope.nix
    ./plugins/treesitter.nix
    ./plugins/which-key.nix
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    # Performance
    performance.byteCompileLua.enable = true;

    # Clipboard (Wayland)
    clipboard.register = "unnamedplus";
    clipboard.providers.wl-copy.enable = true;

    # Colorscheme
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha";
      };
    };

    plugins.web-devicons.enable = true;

    # Status Line (Essential for UX)
    plugins.lualine = {
      enable = true;
      settings.options = {
        theme = "dracula";
      };
    };
  };
}
