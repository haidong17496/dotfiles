{
  description = "Caelestia Rice on NixOS (Unstable)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # --- Caelestia Components ---
    # Shell: The UI (Bar, Launcher, OSD) built with Quickshell (Qt/QML)
    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # CLI: The Logic (Wallpaper handling, colorscheme generation, daemon)
    caelestia-cli = {
      url = "github:caelestia-dots/cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";
  in {
    nixosConfigurations = {
      astral = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};

        modules = [
          ./hosts/astral/default.nix
          ./pkgsConfig.nix

          # Home Manager Integration
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            # Pass inputs to Home Manager modules specifically
            home-manager.extraSpecialArgs = {inherit inputs;};

            # User Configuration
            home-manager.users.nekoma = import ./home/nekoma/default.nix;

            # Safety: Backup existing files instead of erroring out if collision occurs
            home-manager.backupFileExtension = "backup";
          }
        ];
      };
    };
  };
}
