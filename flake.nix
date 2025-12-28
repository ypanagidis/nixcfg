{
  description = "Yiannis' NixOS system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    opencode-flake = {
      url = "github:aodhanhayter/opencode-flake";
    };

  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nix-vscode-extensions,
      opencode-flake,
      ...
    }:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit opencode-flake;
        };

        modules = [
          # Add the overlay so pkgs.nix-vscode-extensions is available everywhere
          (
            { ... }:
            {
              nixpkgs.overlays = [ nix-vscode-extensions.overlays.default ];
            }
          )

          ./configuration.nix
          home-manager.nixosModules.home-manager

          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit opencode-flake; };
            home-manager.users.yiannis = import ./home.nix;
          }
        ];
      };
    };
}
