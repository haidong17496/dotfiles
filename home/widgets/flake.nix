{
  description = "Hyprland Dynamic Island Widget";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            pkg-config
          ];

          buildInputs = with pkgs; [
            rust-bin.stable.latest.default
            dbus
            fontconfig
            libnotify
            
            # --- NEW DEPENDENCIES ---
            pulseaudio   # Provides 'pactl'
            wireplumber  # Provides 'wpctl'
            brightnessctl # Provides 'brightnessctl'

            # Fonts
            nerd-fonts.jetbrains-mono
            noto-fonts
            noto-fonts-cjk-sans
            noto-fonts-color-emoji
            
            # Graphic deps
            wayland
            wayland-protocols
            libxkbcommon
            vulkan-loader
            xorg.libX11
            xorg.libXcursor
            xorg.libXi
            xorg.libXrandr
          ];

          FONTCONFIG_FILE = pkgs.makeFontsConf { 
            fontDirectories = with pkgs; [ 
              nerd-fonts.jetbrains-mono 
              noto-fonts
              noto-fonts-cjk-sans
              noto-fonts-color-emoji
            ]; 
          };

          LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath (with pkgs; [
             wayland
             libxkbcommon
             vulkan-loader
             dbus
             fontconfig
          ]);
        };
      }
    );
}
