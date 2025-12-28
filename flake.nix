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
    };

    outputs = { self, nixpkgs, home-manager, rust-overlay, ... }@inputs: 
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
                            home-manager.users.nekoma = import ./home/default.nix;
                        }
                    ];
                };
            };
        };
}
