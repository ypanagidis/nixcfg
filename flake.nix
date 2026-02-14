{
  description = "Yiannis' multi-host Nix config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    custom-packages = {
      url = "path:./custom-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      darwin,
      home-manager,
      custom-packages,
      ...
    }@inputs:
    let
      nixosConfig = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          {
            nixpkgs.overlays = [ custom-packages.overlays.default ];
          }
          ./hosts/nixos/nix-pc/default.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.yiannis = import ./home/linux.nix;
          }
        ];
      };

      darwinConfig = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit inputs; };
        modules = [
          {
            nixpkgs.overlays = [ custom-packages.overlays.default ];
          }
          ./hosts/darwin/yiannis-mbp/default.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.yiannis = import ./home/darwin.nix;
          }
        ];
      };
    in
    {
      nixosConfigurations = {
        nixos = nixosConfig;
        "nix-pc" = nixosConfig;
      };
      darwinConfigurations = {
        "yiannis-mbp" = darwinConfig;
      };
    };
}
