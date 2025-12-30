{
    description = "Nekoma's system";

    inputs = {
        # 1. NixOS 25.11 stable
        nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

        # 2. Home Manager
        home-manager.url = "github:nix-community/home-manager/release-25.11";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";

        # 3. Rust Overlay (for latest Rust compiler)
        rust-overlay.url = "github:oxalica/rust-overlay";
        rust-overlay.inputs.nixpkgs.follows = "nixpkgs";

        # 4. Walker App Launcher
        elephant.url = "github:abenz1267/elephant";
        walker = { 
          url = "github:abenz1267/walker";
          inputs.elephant.follows = "elephant";
          inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, home-manager, rust-overlay, walker, ... }@inputs: 
        let
            system = "x86_64-linux";
        in {
            nixosConfigurations = {
                astral = nixpkgs.lib.nixosSystem {
                    inherit system;
                    specialArgs = { inherit inputs; };
                    modules = [
                        ./hosts/astral/default.nix
                        ./pkgsConfig.nix
                        {
                            nixpkgs.overlays = [ (import rust-overlay) ];
                        }

                        home-manager.nixosModules.home-manager
                        {
                            home-manager.useGlobalPkgs = true;
                            home-manager.useUserPackages = true;
                            home-manager.extraSpecialArgs = { inherit inputs; };
                            home-manager.users.nekoma = import ./home/default.nix;
                        }
                    ];
                };
            };
        };
}
